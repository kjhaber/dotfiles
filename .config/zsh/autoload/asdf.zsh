if [[ ! -d  "$HOME/.asdf" ]]; then
  echo "Installing asdf"
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf

  echo "Installing nodejs plugin for asdf"
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

  echo "Installing nodejs latest in asdf"
  asdf install nodejs latest

  echo "Setting asdf node version to latest"
  asdf global nodejs latest
fi

source "$HOME/.asdf/asdf.sh"
fpath=($ASDF_DIR/completions $fpath)

