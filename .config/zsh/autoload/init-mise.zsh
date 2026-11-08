export MISE_INSTALL_PATH="$HOME/.local/bin/mise"
export MISE_DATA_DIR="$HOME/.local/share/mise"
export MISE_GLOBAL_CONFIG_FILE="$CONFIG_LOCAL_DIR/mise/config.toml"

mkdir -p "$MISE_DATA_DIR"

# Install mise if not already installed
if [[ ! -f "$MISE_INSTALL_PATH" ]]; then
  echo "Installing mise"
  curl https://mise.run | sh
fi

# Default packages for each tool version come from default-<tool>-packages files
# under ~/.config/mise and ~/.config-local/mise.  They're installed by the
# `[hooks] postinstall = "$HOME/.config/bin/mise-install-default-packages"` in
# the global mise config (mise's default_packages_file settings are deprecated).


# Install node and python if not already installed
if [[ ! -d "$MISE_DATA_DIR/installs/node" ]]; then
  # Installing node because neovim/coc.nvim requires it
  echo "Installing node latest in mise"
  "$MISE_INSTALL_PATH" use -g node@latest
fi

if [[ ! -d "$MISE_DATA_DIR/installs/python" ]]; then
  echo "Installing python latest in mise"
  "$MISE_INSTALL_PATH" use -g python@latest
fi

# see .config/zsh/path.zsh for `mise activate`
