if [[ ! -d  "$HOME/.fzf" ]]; then
  echo "Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all --key-bindings --completion --no-update-rc --no-bash
  echo "Done"
fi

