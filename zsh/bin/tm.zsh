# tm.zsh
#
# Simplifies creating new tmux sessions, attaching to existing sessions,
# and switching between sessions.
#

function tm() {
    [[ -z "$1" ]] && { echo "usage: tm <session>" >&2; return 1; }
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

