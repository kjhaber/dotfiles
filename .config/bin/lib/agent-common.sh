# shellcheck shell=bash
# Shared helpers for agent-capture and agent-restore. Meant to be sourced, not executed.
#
# Environment overrides (mainly for tests):
#   AGENT_TMUX_SOCKET   tmux socket name (-L) to talk to instead of the default server
#   CLAUDE_SESSIONS_DIR directory holding Claude Code's per-process session files

# Field separator for machine-readable records. Unlike tab, a unit separator is
# not treated as whitespace by `read`, so empty fields are preserved.
US=$'\x1f'

agent_tmux() {
  tmux ${AGENT_TMUX_SOCKET:+-L "$AGENT_TMUX_SOCKET"} "$@"
}

# Prints one record per live, interactive Claude Code session, fields joined by $US:
#   tmux_pane_id  pid  session_id  cwd  name
# tmux_pane_id is empty when the session isn't running inside tmux.
# Claude Code writes <pid>.json files under ~/.claude/sessions for each running process.
agent_live_claude_sessions() {
  local dir="${CLAUDE_SESSIONS_DIR:-$HOME/.claude/sessions}" f rec pid
  [ -d "$dir" ] || return 0
  for f in "$dir"/*.json; do
    [ -e "$f" ] || continue
    rec=$(jq -r 'select(.kind == "interactive")
      | [ ((.tmux // "") | sub(".*\\."; "")),
          (.pid | tostring),
          .sessionId,
          (.cwd // ""),
          ((.name // "") | gsub("[\\n\\r\\t]"; " ")) ]
      | join("\u001f")' "$f" 2>/dev/null) || continue
    [ -n "$rec" ] || continue
    pid="${rec#*"$US"}"
    pid="${pid%%"$US"*}"
    kill -0 "$pid" 2>/dev/null || continue
    printf '%s\n' "$rec"
  done
}
