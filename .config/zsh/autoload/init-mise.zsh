export MISE_INSTALL_PATH="$HOME/.local/bin/mise"
export MISE_DATA_DIR="$HOME/.local/share/mise"
export MISE_GLOBAL_CONFIG_FILE="$CONFIG_LOCAL_DIR/mise/config.toml"

mkdir -p "$MISE_DATA_DIR"

# Install mise if not already installed
if [[ ! -f "$MISE_INSTALL_PATH" ]]; then
  echo "Installing mise"
  curl https://mise.run | sh
fi

# Set mise default package lists
# (e.g. https://mise.jdx.dev/lang/python.html#default-python-packages )
export MISE_PYTHON_DEFAULT_PACKAGES_FILE="$HOME/.cache/mise/default-python-packages-merged"
export MISE_NODE_DEFAULT_PACKAGES_FILE="$HOME/.cache/mise/default-node-packages-merged"
export MISE_GO_DEFAULT_PACKAGES_FILE="$HOME/.cache/mise/default-go-packages-merged"
export MISE_RUBY_DEFAULT_PACKAGES_FILE="$HOME/.cache/mise/default-ruby-packages-merged"

# Combine list of packages from `~/.config/mise/default-*-packages` and
# `~/.config-local/mise/default-*-packages` into merged files under
# `~/.cache/mise` directory.
"$HOME/.config/bin/mise-merge-default-packages"


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

