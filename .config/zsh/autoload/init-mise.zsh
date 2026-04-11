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

# Merge default package lists only when source files have changed.
# Uses a sentinel file to track the last merge time.
_mise_sentinel="$HOME/.cache/mise/.last-merge"
_mise_need_merge=false
if [[ ! -f "$_mise_sentinel" ]]; then
  _mise_need_merge=true
else
  for _f in "$HOME/.config/mise"/default-*-packages "$HOME/.config-local/mise"/default-*-packages; do
    [[ -f "$_f" && "$_f" -nt "$_mise_sentinel" ]] && { _mise_need_merge=true; break }
  done
fi
if [[ "$_mise_need_merge" == true ]]; then
  "$HOME/.config/bin/mise-merge-default-packages"
  mkdir -p "${_mise_sentinel:h}"
  touch "$_mise_sentinel"
fi
unset _mise_sentinel _mise_need_merge _f


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
