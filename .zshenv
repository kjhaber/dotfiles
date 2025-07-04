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
export AWS_PAGER=""

export CONFIG_DIR="$HOME/.config"
export CONFIG_LOCAL_DIR="$HOME/.config-local"
export LUA_PATH=";;$CONFIG_DIR/nvim/lua/?.lua;$CONFIG_LOCAL_DIR/nvim/lua/?.lua"

# local environment-specific config
test -f "$CONFIG_LOCAL_DIR/zsh/zshenv-before.zsh" && source "$CONFIG_LOCAL_DIR/zsh/zshenv-before.zsh"

export DOC_DIR="$HOME/Documents"
export DESKTOP_DIR="$HOME/Desktop"
export VIMWIKI_DIR="$DOC_DIR/vimwiki"
export VIMWIKI_DIARY_DIR="$VIMWIKI_DIR/diary"
export PROJECTS_DIR="$HOME/Projects"

# On home machine $REMOTE_SYNC_DIR is a symlink to ~/Dropbox
# At work it's a directory configured to sync with network drive
export REMOTE_SYNC_DIR="$DOC_DIR/RemoteSync"

# local environment-specific config
test -f "$CONFIG_LOCAL_DIR/zsh/zshenv-after.zsh" && source "$CONFIG_LOCAL_DIR/zsh/zshenv-after.zsh"

