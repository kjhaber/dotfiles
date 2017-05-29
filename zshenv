# zshenv
# Limit to variables and settings useful for any usage of zsh, including running
# zsh with a script (exclude anything declared for interactive usage).
#
# Unfortunately we can't set $PATH here because /etc/profile is run after
# .zshenv, which clobbers the $PATH on macOS.  This reduces the utility of zshenv
# to setting certain environment variables only.

export LIB_DIR="$HOME/Library"
export DOTFILE_HOME="$LIB_DIR/dotfiles"
export EXT_REPO_DIR="$LIB_DIR/repos"

export HOMEBREW_NO_ANALYTICS=1

# JAVA_HOME is set mostly for Eclipse.  This is macOS-specific.
export JAVA_HOME=`/usr/libexec/java_home`

