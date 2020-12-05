# tm.zsh
#
# Simplifies creating new tmux sessions, attaching to existing sessions,
# switching between sessions, and listing active sessions.
#

function tm() {
    [[ -z "$1" ]] && {
      echo "Usage: tm <session>"
      echo "Active tmux sessions:"
      tmux ls -F "* #{session_name}"
      return
    }
    [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
    tmux has -t="$1" 2> /dev/null && tmux $change -t "$1" || (TMUX= tmux new -d -s "$1" && tmux $change -t "$1")
}

function __tmux-sessions() {
    local expl
    local -a sessions
    sessions=( ${${(f)"$(command tmux list-sessions 2> /dev/null)"}/:[ $'\t']##/:} )
    _describe -t sessions 'sessions' sessions "$@"
}
compdef __tmux-sessions tm

