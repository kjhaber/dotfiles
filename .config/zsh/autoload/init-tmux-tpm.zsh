if [[ -x "$(which tmux)" && ! -d  "$HOME/.tmux/plugins/tpm" ]]; then
  echo "Installing tmux tpm plugin manager..."
  # install tpm plugin manager
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

  # install tmux plugins
  "$HOME/.tmux/plugins/tpm/bin/install_plugins"
  echo "Done"
fi
