export PATH="$HOME/.local/bin:$PATH"

# Allow environment-specific PATH overrides
# (on Mac/Linux, this is where homebrew is added to PATH)
test -f "$CONFIG_LOCAL_DIR/zsh/path.zsh" && source "$CONFIG_LOCAL_DIR/zsh/path.zsh"

# Add mise (dev tool version manager) shims to PATH
# In general these tools should come before homebrew in PATH
# (Using `eval "$(mise activate --shims zsh)` isn't working consistently for me for some reason)
export PATH="$MISE_DATA_DIR/shims:$PATH"

# Add personal scripts/executables to front of PATH
export PATH="$CONFIG_DIR/bin:$PATH"
export PATH="$CONFIG_LOCAL_DIR/bin:$PATH"

# Add local completion definitions to fpath
fpath=("$CONFIG_LOCAL_DIR/zsh/completions" $fpath)

