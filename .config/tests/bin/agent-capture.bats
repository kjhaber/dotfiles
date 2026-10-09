#!/usr/bin/env bats

load helpers

setup() { common_setup; }
teardown() { common_teardown; }

@test "prints one line per live claude pane in session:window,path,claude:id # name format" {
  proj="$(mkdirp proj)"
  start_session work "$proj"
  register_claude_pane work:1.1 aaaa-1111 "$proj" "my-feature"

  run "$BIN_DIR/agent-capture"
  [ "$status" -eq 0 ]
  [ "$output" = "work:1,$proj,claude:aaaa-1111 # my-feature" ]
}

@test "abbreviates the home directory as ~" {
  mkdir -p "$HOME/projects/cool"
  start_session work "$HOME/projects/cool"
  register_claude_pane work:1.1 aaaa-1111 "$HOME/projects/cool" "n"

  run "$BIN_DIR/agent-capture"
  [ "$status" -eq 0 ]
  [ "$output" = "work:1,~/projects/cool,claude:aaaa-1111 # n" ]
}

@test "omits the trailing comment when the session has no name" {
  proj="$(mkdirp proj)"
  start_session work "$proj"
  register_claude_pane work:1.1 aaaa-1111 "$proj"

  run "$BIN_DIR/agent-capture"
  [ "$status" -eq 0 ]
  [ "$output" = "work:1,$proj,claude:aaaa-1111" ]
}

@test "split panes appear as separate lines sharing a window key, ordered by pane" {
  proj="$(mkdirp proj)"
  start_session work "$proj"
  tm split-window -d -t work:1 -c "$proj"
  register_claude_pane work:1.2 bbbb-2222 "$proj" "bottom"
  register_claude_pane work:1.1 aaaa-1111 "$proj" "top"

  run "$BIN_DIR/agent-capture"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "work:1,$proj,claude:aaaa-1111 # top" ]
  [ "${lines[1]}" = "work:1,$proj,claude:bbbb-2222 # bottom" ]
  [ "${#lines[@]}" -eq 2 ]
}

@test "output is ordered by session name, then window index" {
  proj="$(mkdirp proj)"
  start_session zeta "$proj"
  start_session alpha "$proj"
  tm new-window -d -t alpha:2 -c "$proj"
  register_claude_pane zeta:1.1 id-z "$proj"
  register_claude_pane alpha:2.1 id-a2 "$proj"
  register_claude_pane alpha:1.1 id-a1 "$proj"

  run "$BIN_DIR/agent-capture"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "alpha:1,$proj,claude:id-a1" ]
  [ "${lines[1]}" = "alpha:2,$proj,claude:id-a2" ]
  [ "${lines[2]}" = "zeta:1,$proj,claude:id-z" ]
}

@test "ignores session files whose process is no longer running" {
  proj="$(mkdirp proj)"
  start_session work "$proj"
  write_session_file 999999 dead-id "$proj" "work:$(pane_ref work:1.1)" "ghost"

  run "$BIN_DIR/agent-capture"
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "ignores sessions that are not running inside tmux" {
  proj="$(mkdirp proj)"
  start_session work "$proj"
  write_session_file "$(live_pid)" no-tmux-id "$proj" ""

  run "$BIN_DIR/agent-capture"
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "ignores sessions pointing at a tmux pane that no longer exists" {
  proj="$(mkdirp proj)"
  start_session work "$proj"
  write_session_file "$(live_pid)" stale-id "$proj" "work:@99.%99"

  run "$BIN_DIR/agent-capture"
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "ignores non-interactive claude sessions" {
  proj="$(mkdirp proj)"
  start_session work "$proj"
  register_claude_pane work:1.1 bg-id "$proj" "bg" "background"

  run "$BIN_DIR/agent-capture"
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "succeeds with empty output when the sessions directory does not exist" {
  proj="$(mkdirp proj)"
  start_session work "$proj"
  export CLAUDE_SESSIONS_DIR="$TEST_ROOT/does-not-exist"

  run "$BIN_DIR/agent-capture"
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "fails with a clear message when no tmux server is running" {
  run "$BIN_DIR/agent-capture"
  [ "$status" -eq 1 ]
  [[ "$output" == *"tmux"* ]]
}

@test "-c copies the capture to the clipboard instead of printing it" {
  proj="$(mkdirp proj)"
  start_session work "$proj"
  register_claude_pane work:1.1 aaaa-1111 "$proj" "n"
  printf '#!/bin/sh\ncat > "%s/clipboard"\n' "$TEST_ROOT" > "$TEST_ROOT/stubs/pbcopy"
  chmod +x "$TEST_ROOT/stubs/pbcopy"

  run "$BIN_DIR/agent-capture" -c
  [ "$status" -eq 0 ]
  [ -z "$output" ]
  [ "$(cat "$TEST_ROOT/clipboard")" = "work:1,$proj,claude:aaaa-1111 # n" ]
}

@test "rejects unknown options" {
  run "$BIN_DIR/agent-capture" --bogus
  [ "$status" -eq 2 ]
  [[ "$output" == *"Usage"* ]]
}
