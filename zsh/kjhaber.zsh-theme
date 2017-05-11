# kjhaber.zsh-theme

setopt prompt_subst

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

# Adds git branch to prompt when pwd is in git repo
git_rprompt() {
  CURBRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ "$CURBRANCH" = "" ] ; then
    echo ""
  else
    echo " %{$fg[magenta]%}[$CURBRANCH]%{$reset_color%}"
  fi
}


PROMPT='%{$fg[${VIMODE_COLOR}]%}${VIMODE_TXT}%{$fg[white]%}%n@%m%#%{$reset_color%} '
RPROMPT='%{$fg[red]%}[%1~]%{$reset_color%}$(git_rprompt)'

