# Shared helpers for bats tests of agent-capture / agent-restore.
# Each test gets an isolated tmux server (own socket), a fake
# ~/.claude/sessions directory, and a fake HOME.

BIN_DIR="$(cd "$BATS_TEST_DIRNAME/../../bin" && pwd -P)"

common_setup() {
  TEST_ROOT="$(cd "$BATS_TEST_TMPDIR" && pwd -P)"
  export HOME="$TEST_ROOT/home"
  mkdir -p "$HOME"
  printf "set -g base-index 1\nset -g pane-base-index 1\n" > "$HOME/.tmux.conf"
  unset TMUX TMUX_PANE
  export SHELL=/bin/sh
  export AGENT_TMUX_SOCKET="agent-test-$$-$BATS_TEST_NUMBER"
  export CLAUDE_SESSIONS_DIR="$TEST_ROOT/sessions"
  mkdir -p "$CLAUDE_SESSIONS_DIR"
  mkdir -p "$TEST_ROOT/stubs"
  export PATH="$TEST_ROOT/stubs:$PATH"
}

common_teardown() {
  tmux -L "$AGENT_TMUX_SOCKET" kill-server 2>/dev/null || true
  local pid
  if [ -f "$TEST_ROOT/live-pids" ]; then
    while read -r pid; do kill "$pid" 2>/dev/null || true; done < "$TEST_ROOT/live-pids"
  fi
}

# Close bats' fd 3 so long-lived children (tmux server, sleeps) don't keep bats waiting.
tm() { tmux -L "$AGENT_TMUX_SOCKET" "$@" 3>&-; }

# mkdirp <name> -> creates $TEST_ROOT/<name> and prints its path
mkdirp() {
  mkdir -p "$TEST_ROOT/$1"
  echo "$TEST_ROOT/$1"
}

# start_session <name> <dir>
start_session() { tm new-session -d -s "$1" -c "$2" -x 200 -y 50; }

# pane_ref <tmux-target> -> "@window.%pane", the format Claude writes in its session file
pane_ref() { tm display-message -p -t "$1" '#{window_id}.#{pane_id}'; }

# live_pid -> prints the pid of a background process that stays alive until teardown
live_pid() {
  sleep 300 < /dev/null > /dev/null 2>&1 3>&- &
  local pid=$!
  echo "$pid" >> "$TEST_ROOT/live-pids"
  echo "$pid"
}

# write_session_file <pid> <session-id> <cwd> <tmux-field> [name] [kind]
write_session_file() {
  local pid="$1" id="$2" cwd="$3" tmuxf="$4" name="${5:-}" kind="${6:-interactive}"
  jq -n --argjson pid "$pid" --arg id "$id" --arg cwd "$cwd" --arg tmux "$tmuxf" \
        --arg name "$name" --arg kind "$kind" \
    '{pid:$pid, sessionId:$id, cwd:$cwd, kind:$kind}
     + (if $tmux == "" then {} else {tmux:$tmux} end)
     + (if $name == "" then {} else {name:$name} end)' \
    > "$CLAUDE_SESSIONS_DIR/$pid.json"
}

# register_claude_pane <tmux-target> <session-id> <cwd> [name] [kind]
# Writes a session file for a live fake process, pointing at the given pane.
register_claude_pane() {
  local target="$1" id="$2" cwd="$3" name="${4:-}" kind="${5:-interactive}"
  local sess="${target%%:*}"
  write_session_file "$(live_pid)" "$id" "$cwd" "$sess:$(pane_ref "$target")" "$name" "$kind"
}

# A stand-in for the claude binary: records cwd and args, then stays alive.
make_fake_claude() {
  export CLAUDE_LOG="$TEST_ROOT/claude.log"
  cat > "$TEST_ROOT/stubs/fake-claude" <<'EOF'
#!/bin/sh
echo "$PWD $*" >> "$CLAUDE_LOG"
sleep 300
EOF
  chmod +x "$TEST_ROOT/stubs/fake-claude"
  export AGENT_CLAUDE_CMD="$TEST_ROOT/stubs/fake-claude"
}

# wait_for_log_line <fixed-string> : polls up to ~5s for a line in the claude log
wait_for_log_line() {
  local i
  for ((i = 0; i < 50; i++)); do
    grep -qF -- "$1" "$CLAUDE_LOG" 2>/dev/null && return 0
    sleep 0.1
  done
  echo "timed out waiting for '$1' in claude log:" >&2
  cat "$CLAUDE_LOG" >&2 2>/dev/null || true
  return 1
}
