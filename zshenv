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

export CONFIG_DIR="$HOME/.config"

export DOTFILE_HOME="$CONFIG_DIR/dotfiles"
export DOTFILE_LOCAL_HOME="$CONFIG_DIR/dotfiles-local"

# local environment-specific config (can't run before DOTFILE_LOCAL_HOME is set)
test -f "${DOTFILE_LOCAL_HOME}/zshenv-local.before" && source "${DOTFILE_LOCAL_HOME}/zshenv-local.before"

export DOC_DIR="$HOME/Documents"
export VIMWIKI_DIR="$DOC_DIR/vimwiki"
export VIMWIKI_DIARY_DIR="$VIMWIKI_DIR/diary"
export EXT_REPO_DIR="$CONFIG_DIR/repos"

# On home machine $REMOTE_SYNC_DIR is a symlink to ~/Dropbox
# At work it's a directory configured to sync with network drive
export REMOTE_SYNC_DIR="$DOC_DIR/RemoteSync"

export HOMEBREW_NO_ANALYTICS=1

# JAVA_HOME is set mostly for Eclipse.  This is macOS-specific.
# (Set it in zshenv-local.after if needed on other OSes.)
if [[ -e "/usr/libexec/java_home" ]] then
  export JAVA_HOME=`/usr/libexec/java_home`
fi

# local environment-specific config
test -f "${DOTFILE_LOCAL_HOME}/zshenv-local.after" && source "${DOTFILE_LOCAL_HOME}/zshenv-local.after"
