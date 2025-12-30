if [[ -x "$(which tmux)" && ! -d  "$HOME/.tmux/plugins/tpm" ]]; then
  # install tpm plugin manager
  echo "Installing tmux tpm plugin manager..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  "$HOME/.tmux/plugins/tpm/bin/clean_plugins"
  "$HOME/.tmux/plugins/tpm/bin/install_plugins"
  echo "Done"
fi
