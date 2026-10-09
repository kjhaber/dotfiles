#!/usr/bin/env bats

load helpers

setup() {
  common_setup
  make_fake_claude
}
teardown() { common_teardown; }

# Runs agent-restore with the given text on stdin.
# (3>&- keeps the tmux server it may start from holding bats' fd 3 open.)
restore() { printf '%s\n' "$1" | "$BIN_DIR/agent-restore" 3>&-; }

@test "creates a missing tmux session and resumes claude in the right directory" {
  proj="$(mkdirp proj)"

  run restore "work:1,$proj,claude:aaaa-1111 # my-feature"
  [ "$status" -eq 0 ]
  tm has-session -t work
  wait_for_log_line "$proj --resume aaaa-1111"
}

@test "places the window at the captured index" {
  proj="$(mkdirp proj)"

  run restore "work:3,$proj,claude:aaaa-1111"
  [ "$status" -eq 0 ]
  [ "$(tm list-windows -t work -F '#{window_index}')" = "3" ]
}

@test "lines sharing a window key become split panes of one window" {
  proj="$(mkdirp proj)"

  run restore "work:1,$proj,claude:aaaa-1111
work:1,$proj,claude:bbbb-2222"
  [ "$status" -eq 0 ]
  [ "$(tm list-windows -t work | wc -l | tr -d ' ')" -eq 1 ]
  [ "$(tm list-panes -t work:1 | wc -l | tr -d ' ')" -eq 2 ]
  wait_for_log_line "--resume aaaa-1111"
  wait_for_log_line "--resume bbbb-2222"
}

@test "multiple windows and sessions are all created" {
  proj="$(mkdirp proj)"

  run restore "alpha:1,$proj,claude:id-a1
alpha:2,$proj,claude:id-a2
beta:1,$proj,claude:id-b1"
  [ "$status" -eq 0 ]
  [ "$(tm list-windows -t alpha -F '#{window_index}' | tr '\n' ' ')" = "1 2 " ]
  tm has-session -t beta
  wait_for_log_line "--resume id-a1"
  wait_for_log_line "--resume id-a2"
  wait_for_log_line "--resume id-b1"
}

@test "adds windows to an existing session without recreating it or touching its windows" {
  proj="$(mkdirp proj)"
  start_session work "$proj"
  original_window="$(tm display-message -p -t work:1 '#{window_id}')"

  run restore "work:2,$proj,claude:aaaa-1111"
  [ "$status" -eq 0 ]
  [ "$(tm list-sessions | wc -l | tr -d ' ')" -eq 1 ]
  [ "$(tm display-message -p -t work:1 '#{window_id}')" = "$original_window" ]
  [ "$(tm list-windows -t work | wc -l | tr -d ' ')" -eq 2 ]
  wait_for_log_line "--resume aaaa-1111"
}

@test "appends a window when the captured index is already taken in an existing session" {
  proj="$(mkdirp proj)"
  start_session work "$proj"

  run restore "work:1,$proj,claude:aaaa-1111"
  [ "$status" -eq 0 ]
  [ "$(tm list-windows -t work | wc -l | tr -d ' ')" -eq 2 ]
  wait_for_log_line "--resume aaaa-1111"
}

@test "skips claude sessions that are already running" {
  proj="$(mkdirp proj)"
  start_session work "$proj"
  register_claude_pane work:1.1 running-id "$proj"

  run restore "other:1,$proj,claude:running-id"
  [ "$status" -eq 0 ]
  [[ "$output" == *"already running"* ]]
  ! tm has-session -t other
  [ ! -e "$CLAUDE_LOG" ]
}

@test "warns about and skips a missing directory, still restoring the other lines, and exits 1" {
  proj="$(mkdirp proj)"

  run restore "work:1,$TEST_ROOT/gone,claude:bad-id
work:2,$proj,claude:good-id"
  [ "$status" -eq 1 ]
  [[ "$output" == *"$TEST_ROOT/gone"* ]]
  wait_for_log_line "--resume good-id"
  ! grep -qF "bad-id" "$CLAUDE_LOG"
}

@test "warns about and skips unknown app prefixes and malformed lines, exiting 1" {
  proj="$(mkdirp proj)"

  run restore "work:1,$proj,vim:notes.md
this is not a capture line
work:2,$proj,claude:good-id"
  [ "$status" -eq 1 ]
  [[ "$output" == *"vim:notes.md"* ]]
  wait_for_log_line "--resume good-id"
}

@test "ignores blank lines, comment lines and trailing comments" {
  proj="$(mkdirp proj)"

  run restore "
# captured 2026-10-08

work:1,$proj,claude:aaaa-1111 # some name with, commas
"
  [ "$status" -eq 0 ]
  wait_for_log_line "$proj --resume aaaa-1111"
  [ "$(wc -l < "$CLAUDE_LOG" | tr -d ' ')" -eq 1 ]
}

@test "expands ~ to the home directory" {
  mkdir -p "$HOME/projects/cool"

  run restore "work:1,~/projects/cool,claude:aaaa-1111"
  [ "$status" -eq 0 ]
  wait_for_log_line "$HOME/projects/cool --resume aaaa-1111"
}

@test "-c reads the capture from the clipboard" {
  proj="$(mkdirp proj)"
  printf '#!/bin/sh\necho "work:1,%s,claude:clip-id"\n' "$proj" > "$TEST_ROOT/stubs/pbpaste"
  chmod +x "$TEST_ROOT/stubs/pbpaste"

  run "$BIN_DIR/agent-restore" -c 3>&-
  [ "$status" -eq 0 ]
  wait_for_log_line "--resume clip-id"
}

@test "rejects unknown options" {
  run "$BIN_DIR/agent-restore" --bogus
  [ "$status" -eq 2 ]
  [[ "$output" == *"Usage"* ]]
}
