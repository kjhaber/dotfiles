export MISE_INSTALL_PATH="$HOME/.local/bin/mise"
export MISE_DATA_DIR="$HOME/.local/share/mise"
export MISE_GLOBAL_CONFIG_FILE="$CONFIG_LOCAL_DIR/mise/config.toml"

mkdir -p "$MISE_DATA_DIR"

if [[ ! -f "$MISE_INSTALL_PATH" ]]; then
  echo "Installing mise"
  curl https://mise.run | sh
fi

if [[ ! -d "$MISE_DATA_DIR/installs/java" ]]; then
  echo "Installing java latest in mise"
  "$MISE_INSTALL_PATH" use -g java@latest
fi

if [[ ! -d "$MISE_DATA_DIR/installs/node" ]]; then
  echo "Installing node latest in mise"
  "$MISE_INSTALL_PATH" use -g node@latest
fi

if [[ ! -d "$MISE_DATA_DIR/installs/python" ]]; then
  echo "Installing python latest in mise"
  "$MISE_INSTALL_PATH" use -g python@latest
fi

# see .config/zsh/path.zsh for `mise activate`

