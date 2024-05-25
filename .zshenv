# zshenv
# Limit to variables and settings useful for any usage of zsh, including running
# zsh with a script (exclude anything declared for interactive usage).
#
# Unfortunately we can't set $PATH here because /etc/profile is run after
# .zshenv, which clobbers the $PATH on macOS.  This reduces the utility of zshenv
# to setting certain environment variables only.
#
# Also note that tmux panes execute zshenv twice (but zshrc once) when the config
# runs  "set -g default-command 'reattach-to-user-namespace -l zsh'".  Slow code
# in shell init is bad, but that literally goes double for zshenv. :)

export HOMEBREW_NO_ANALYTICS=1

export CONFIG_DIR="$HOME/.config"
export CONFIG_LOCAL_DIR="$HOME/.config-local"

# local environment-specific config
test -f "$CONFIG_LOCAL_DIR/zsh/zshenv-before.zsh" && source "$CONFIG_LOCAL_DIR/zsh/zshenv-before.zsh"

export DOC_DIR="$HOME/Documents"
export VIMWIKI_DIR="$DOC_DIR/vimwiki"
export VIMWIKI_DIARY_DIR="$VIMWIKI_DIR/diary"

# On home machine $REMOTE_SYNC_DIR is a symlink to ~/Dropbox
# At work it's a directory configured to sync with network drive
export REMOTE_SYNC_DIR="$DOC_DIR/RemoteSync"

export ASDF_CONFIG_FILE="$CONFIG_DIR/asdf/asdfrc"
export ASDF_DIR="$CONFIG_LOCAL_DIR/asdf"
export ASDF_DATA_DIR="$CONFIG_LOCAL_DIR/asdf"

# local environment-specific config
test -f "$CONFIG_LOCAL_DIR/zsh/zshenv-after.zsh" && source "$CONFIG_LOCAL_DIR/zsh/zshenv-after.zsh"

