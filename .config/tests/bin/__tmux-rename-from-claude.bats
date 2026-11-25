#!/usr/bin/env bats

# __tmux-rename-from-claude renames a tmux window to its Claude session's
# explicit (/rename) name. Tests run against an isolated tmux server; a tmux
# wrapper stub logs every call so status-bar messages can be asserted (there is
# no attached client to display them).

load helpers

setup() {
  common_setup
  # Short socket dir (macOS caps socket paths ~104 chars) that also keeps any
  # tmux call missing -L away from the real default server.
  export TMUX_TMPDIR="$(mktemp -d /tmp/tmux-rename-test.XXXX)"
  export TMUX_CALL_LOG="$TEST_ROOT/tmux-calls.log"
  local real_tmux
  real_tmux="$(command -v tmux)"
  cat > "$TEST_ROOT/stubs/tmux" <<EOF
#!/bin/sh
echo "\$*" >> "\$TMUX_CALL_LOG"
exec "$real_tmux" "\$@"
EOF
  chmod +x "$TEST_ROOT/stubs/tmux"

  start_session s1 "$TEST_ROOT"
  WIN="$(tm display-message -p -t s1 '#{window_id}')"
}

teardown() {
  common_teardown
  rm -rf "$TMUX_TMPDIR"
}

# named_pane <name> <name-source> [tmux-field] : session file for a live fake claude
named_pane() {
  write_session_file "$(live_pid)" "id-$RANDOM" "$TEST_ROOT" "${3:-s1:$WIN.%0}" "$1" interactive "$2"
}

window_name() { tm display-message -p -t "$WIN" '#{window_name}'; }

rename() { run "$BIN_DIR/__tmux-rename-from-claude" "$@"; }

assert_message() {
  grep -F "display-message $1" "$TMUX_CALL_LOG" || { cat "$TMUX_CALL_LOG" >&2; return 1; }
}

@test "renames window to the user-named session in it" {
  named_pane my-task user
  rename "$WIN"
  [ "$status" -eq 0 ]
  [ "$(window_name)" = my-task ]
}

@test "defaults to the current window when no window id is given" {
  named_pane my-task user
  rename
  [ "$status" -eq 0 ]
  [ "$(window_name)" = my-task ]
}

@test "ignores derived (auto-generated) session names" {
  before="$(window_name)"
  named_pane config-d6 derived
  rename "$WIN"
  [ "$status" -eq 0 ]
  [ "$(window_name)" = "$before" ]
  assert_message "No named Claude session"
}

@test "shows a message when there are no sessions" {
  rename "$WIN"
  [ "$status" -eq 0 ]
  assert_message "No named Claude session"
}

@test "does not rename when two differently named sessions share the window" {
  before="$(window_name)"
  named_pane one user
  named_pane two user "s1:$WIN.%9"
  rename "$WIN"
  [ "$status" -eq 0 ]
  [ "$(window_name)" = "$before" ]
  assert_message "Multiple named Claude sessions"
  grep -F one "$TMUX_CALL_LOG" && grep -F two "$TMUX_CALL_LOG"
}

@test "treats two sessions with the same name as one" {
  named_pane same user
  named_pane same user "s1:$WIN.%9"
  rename "$WIN"
  [ "$(window_name)" = same ]
}

@test "ignores stale session files whose process has exited" {
  sh -c 'exit 0' &
  dead=$!
  wait "$dead"
  write_session_file "$dead" id-dead "$TEST_ROOT" "s1:$WIN.%0" stale interactive user
  rename "$WIN"
  [ "$(window_name)" != stale ]
  assert_message "No named Claude session"
}

@test "matches the window id exactly (@0 does not match @00)" {
  named_pane right user
  named_pane wrong user "s1:${WIN}0.%9"
  rename "$WIN"
  [ "$(window_name)" = right ]
}

@test "preserves names containing spaces" {
  named_pane "has spaces" user
  rename "$WIN"
  [ "$(window_name)" = "has spaces" ]
}

@test "skips session files that are malformed or lack a tmux field" {
  echo 'not json' > "$CLAUDE_SESSIONS_DIR/1.json"
  write_session_file "$(live_pid)" id-x "$TEST_ROOT" "" no-tmux interactive user
  named_pane good user
  rename "$WIN"
  [ "$status" -eq 0 ]
  [ "$(window_name)" = good ]
}
