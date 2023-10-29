# Last piece of the puzzle for seamlessly switching tmux panes and vim splits
# with ctrl h/j/k/l (vim-tmux-navigator).  Something about vi mode in zsh
# triggers the normal vim word delete command when using ctrl-h.  This defines
# an alternate zle widget and overrides the binding for ctrl-h only when in a
# tmux session.
#
# Other last piece: this seems to work best with neovim rather than regular vim.
#
# (BTW, in iTerm2, be sure to map Ctrl-H to send escape sequence [104;5u
# This is CSI code for otherwise terminal will send <BS> key, which won't trigger
# Ctrl-H mappings.  See also https://gitlab.com/gnachman/iterm2/issues/3519 )
function ctrl-h-widget() {
  tmux select-pane -L
}
if [ -n "$TMUX" ]; then
  zle -N ctrl-h-widget
  bindkey '^H' ctrl-h-widget
  bindkey '^[[104;5u' ctrl-h-widget
fi


