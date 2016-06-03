bindkey -v

autoload -U compinit colors

fpath=(~/.zsh/completion $fpath)
compinit
colors


setopt prompt_subst
#setopt correct_all
setopt complete_in_word
setopt auto_cd

HISTFILE=~/.zsh-histfile
HISTSIZE=5000
SAVEHIST=5000
setopt inc_append_history
setopt share_history
setopt extended_history
setopt hist_ignore_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

git_rprompt() {
  CURBRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ "$CURBRANCH" = "" ] ; then
    echo ""
  else
    echo " %{$fg[magenta]%}[$CURBRANCH]%{$reset_color%}"
  fi
}

PROMPT='%{$fg[white]%}%n@%m%#%{$reset_color%} '
RPROMPT='%{$fg[red]%}[%1~]%{$reset_color%}$(git_rprompt)'

precmd () { print -Pn "\e]2;%n@%M | ${PWD##*/}\a" } # title bar prompt

function tm() {
    [[ -z "$1" ]] && { echo "usage: tm <session>" >&2; return 1; }
    tmux has -t $1 && tmux attach -t $1 || tmux new -s $1
}

function __tmux-sessions() {
    local expl
    local -a sessions
    sessions=( ${${(f)"$(command tmux list-sessions 2> /dev/null)"}/:[ $'\t']##/:} )
    _describe -t sessions 'sessions' sessions "$@"
}
compdef __tmux-sessions tm

