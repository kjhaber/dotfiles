# zshenv
# Limit to variables and settings useful for any usage of zsh, including running
# zsh with a script (exclude anything declared for interactive usage).
#
# Unfortunately we can't set $PATH here because /etc/profile is run after
# .zshenv, which clobbers the $PATH on macOS.  This reduces the utility of zshenv
# to setting certain environment variables only.

export LIB_DIR="$HOME/Library"
export DOTFILE_HOME="$LIB_DIR/dotfiles"
export DOTFILE_LOCAL_HOME="$LIB_DIR/dotfiles-local"
export DOC_DIR="$HOME/Documents"
export VIMWIKI_DIR="$DOC_DIR/vimwiki"
export VIMWIKI_DIARY_DIR="$VIMWIKI_DIR/diary"
export EXT_REPO_DIR="$LIB_DIR/repos"

# On home machine $REMOTE_SYNC_DIR is a symlink to ~/Dropbox
# At work it's a directory configured to sync with network drive
export REMOTE_SYNC_DIR="$DOC_DIR/RemoteSync"
export TODO_DIR="$REMOTE_SYNC_DIR/todo"
if [[ ! -d "$REMOTE_SYNC_DIR" ]] then
  echo "Warning: REMOTE_SYNC_DIR does not exist ($REMOTE_SYNC_DIR)"
  export TODO_DIR="$HOME/.config/todo"
fi

export HOMEBREW_NO_ANALYTICS=1

# JAVA_HOME is set mostly for Eclipse.  This is macOS-specific.
export JAVA_HOME=`/usr/libexec/java_home`

