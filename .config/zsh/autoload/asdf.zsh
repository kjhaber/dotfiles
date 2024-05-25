if [[ ! -d  "$ASDF_DATA_DIR" ]]; then
  echo "Installing asdf"
  git clone https://github.com/asdf-vm/asdf.git "$ASDF_DATA_DIR"
  source "$ASDF_DATA_DIR/asdf.sh"

  echo "Installing nodejs plugin for asdf"
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

  echo "Installing nodejs latest in asdf"
  asdf install nodejs latest

  echo "Setting asdf node version to latest"
  asdf global nodejs latest

  echo "Installing java plugin for asdf"
  asdf plugin add java https://github.com/halcyon/asdf-java.git

  echo "Installing java latest (OpenJDK) in asdf"
  asdf install java latest:adoptopenjdk

  echo "Setting asdf node version to latest"
  asdf global java latest:adoptopenjdk
fi

source "$ASDF_DATA_DIR/asdf.sh"
fpath=($ASDF_DATA_DIR/completions $fpath)

