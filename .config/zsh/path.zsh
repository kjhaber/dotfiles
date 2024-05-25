export PATH="$HOME/.local/bin:$PATH"

# Allow environment-specific PATH overrides
# (on Mac/Linux, this is where homebrew is added to PATH)
test -f "$CONFIG_LOCAL_DIR/zsh/path.zsh" && source "$CONFIG_LOCAL_DIR/zsh/path.zsh"

# Add mise (dev tool version manager) shims to PATH
# In general these tools should come before homebrew in PATH
eval "$($MISE_INSTALL_PATH activate --shims zsh)"

# Add personal scripts/executables to front of PATH
export PATH="$CONFIG_DIR/bin:$PATH"
export PATH="$CONFIG_LOCAL_DIR/bin:$PATH"

