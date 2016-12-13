bindkey -v
export KEYTIMEOUT=1

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

# configure fuzzy autocomplete on tab
zstyle ':completion:*' matcher-list '' \
'm:{a-z\-}={A-Z\_}' \
'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
'r:[[:ascii:]]||[[:ascii:]]=** r:|=* m:{a-z\-}={A-Z\_}'

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

# Add vim mode indicator to beginning of PROMPT.
# Setting color code within zle-keymap-select didn't work for me, but using
# separate variables for text and color works.
VIMODE_INSERT_TXT='↪ '
VIMODE_NORMAL_TXT='✦ '
VIMODE_TXT=$VIMODE_INSERT_TXT
VIMODE_INSERT_COLOR='cyan'
VIMODE_NORMAL_COLOR='magenta'
VIMODE_COLOR=$VIMODE_INSERT_COLOR
function zle-line-init zle-keymap-select {
    VIMODE_TXT="${${KEYMAP/vicmd/${VIMODE_NORMAL_TXT}}/(main|viins)/${VIMODE_INSERT_TXT}}"
    VIMODE_COLOR="${${KEYMAP/vicmd/${VIMODE_NORMAL_COLOR}}/(main|viins)/${VIMODE_INSERT_COLOR}}"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

PROMPT='%{$fg[${VIMODE_COLOR}]%}${VIMODE_TXT}%{$fg[white]%}%n@%m%#%{$reset_color%} '
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

