# tm.zsh
#
# Simplifies creating new tmux sessions and attaching to existing sessions.
#

function tm() {
    [[ -z "$1" ]] && { echo "usage: tm <session>" >&2; return 1; }
    tmux has -t "$1" 2> /dev/null && tmux attach -t "$1" || tmux new -s "$1"
}

function __tmux-sessions() {
    local expl
    local -a sessions
    sessions=( ${${(f)"$(command tmux list-sessions 2> /dev/null)"}/:[ $'\t']##/:} )
    _describe -t sessions 'sessions' sessions "$@"
}
compdef __tmux-sessions tm

