# From https://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
# For fast switching between vim and shell.  Ctrl-Z in vim to put it into
# the background, then Ctrl-Z again to bring it back.
function ctrl-z-widget() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N ctrl-z-widget
bindkey '^Z' ctrl-z-widget

