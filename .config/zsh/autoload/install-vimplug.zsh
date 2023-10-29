if [[ ! -f  "$HOME/.config/nvim/autoload/plug.vim" ]]; then
  echo "Installing vimplug..."
  curl -fLo "$HOME/.config/nvim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo "Done"
fi

