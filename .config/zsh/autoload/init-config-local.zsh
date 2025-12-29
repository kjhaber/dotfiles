if [[ ! -d  "$HOME/.config-local" ]]; then
  echo "Creating .config-local directory"
  mkdir -p "$HOME/.config-local"
fi

if [[ ! -d  "$HOME/.config-local/nvim/snippets" ]]; then
  echo "Creating .config-local/nvim/snippets directory"
  mkdir -p "$HOME/.config-local/nvim/snippets"
fi

