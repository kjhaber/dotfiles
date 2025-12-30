if [[ -x "$(which tmux)" && ! -d  "$HOME/.tmux/plugins/tpm" ]]; then
  echo "Installing tmux tpm plugin manager..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  echo "Done - Use \`<tmux>-I\` within tmux session to install plugins"
fi
