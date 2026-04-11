export PATH="$HOME/.local/bin:$PATH"

# Load Homebrew into PATH and set up completions.
# Cache shellenv output to avoid a subprocess on every startup.
# Cache is invalidated when the brew binary itself is updated.
_brew_env_cache="$HOME/.cache/zsh/brew-env.zsh"
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  if [[ ! -f "$_brew_env_cache" ]] || [[ "/opt/homebrew/bin/brew" -nt "$_brew_env_cache" ]]; then
    mkdir -p "${_brew_env_cache:h}"
    /opt/homebrew/bin/brew shellenv > "$_brew_env_cache"
  fi
  source "$_brew_env_cache"
  fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  if [[ ! -f "$_brew_env_cache" ]] || [[ "/home/linuxbrew/.linuxbrew/bin/brew" -nt "$_brew_env_cache" ]]; then
    mkdir -p "${_brew_env_cache:h}"
    /home/linuxbrew/.linuxbrew/bin/brew shellenv > "$_brew_env_cache"
  fi
  source "$_brew_env_cache"
  fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi
unset _brew_env_cache

# Allow environment-specific PATH overrides
test -f "$CONFIG_LOCAL_DIR/zsh/path.zsh" && source "$CONFIG_LOCAL_DIR/zsh/path.zsh"

# Add mise (dev tool version manager) shims to PATH
# In general these tools should come before homebrew in PATH
# (Using `eval "$(mise activate --shims zsh)` isn't working consistently for me for some reason)
export PATH="$MISE_DATA_DIR/shims:$PATH"

# Add personal scripts/executables to front of PATH
export PATH="$CONFIG_DIR/bin:$PATH"
export PATH="$CONFIG_LOCAL_DIR/bin:$PATH"

# Add local completion definitions to fpath
fpath=("$CONFIG_DIR/zsh/completions" $fpath)
fpath=("$CONFIG_LOCAL_DIR/zsh/completions" $fpath)
