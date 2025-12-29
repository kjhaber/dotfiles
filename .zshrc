# zshrc
# Declares variables and settings useful for any interactive usage of zsh, such
# as prompt, shortcuts, zsh feature settings, etc.

# Apply local environment-specific config
test -f "$CONFIG_LOCAL_DIR/zsh/zshrc-before.zsh" && source "$CONFIG_LOCAL_DIR/zsh/zshrc-before.zsh"

export EDITOR=nvim
export PAGER=less
export CLICOLOR=1
export KEYTIMEOUT=1
export LESS="--ignore-case --use-color"

bindkey -v

# Use `<ESC>v` to edit current command line in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

autoload -U colors
colors

setopt complete_in_word
setopt auto_cd

HISTFILE=$HOME/.zsh-histfile
HISTSIZE=5000
SAVEHIST=5000
setopt inc_append_history
setopt share_history
setopt extended_history
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt transient_rprompt

# Set up prompt
source $CONFIG_DIR/zsh/kjhaber.zsh-theme

# Set title bar prompt
precmd () {
  print -Pn "\e]2;%n@%M | ${PWD##*/}\a" # iterm2 window title
  print -Pn "\e]1;${PWD##*/}\a"         # iterm2 tab title
}


# Prevent accidentally entering zsh command mode (execute-named-cmd) when I hit esc
# (https://superuser.com/questions/928846/what-is-execute-on-the-command-line-and-how-to-i-avoid-it)
bindkey -a -r ':'

# Import aliases
source $CONFIG_DIR/zsh/aliases.zsh
test -f "$CONFIG_LOCAL_DIR/zsh/aliases.zsh" && source "$CONFIG_LOCAL_DIR/zsh/aliases.zsh"

# https://stackoverflow.com/questions/68786631/how-do-i-configure-zsh-for-completion-of-partial-words-but-case-insensitive
zstyle ':completion:*' matcher-list \
    'm:{[:lower:]}={[:upper:]}' \
    '+r:|[._-]=* r:|=*' \
    '+l:|=*'

# mise default packages
export MISE_PYTHON_DEFAULT_PACKAGES_FILE="$CONFIG_LOCAL_DIR/mise/default-python-packages"
export MISE_NODE_DEFAULT_PACKAGES_FILE="$CONFIG_LOCAL_DIR/mise/default-node-packages"
export MISE_GO_DEFAULT_PACKAGES_FILE="$CONFIG_LOCAL_DIR/mise/default-go-packages"
export MISE_RUBY_DEFAULT_PACKAGES_FILE="$CONFIG_LOCAL_DIR/mise/default-ruby-packages"

# zsh-autoswitch-virtualenv options
export AUTOSWITCH_DEFAULT_PYTHON="$HOME/.local/share/mise/shims/python"
export AUTOSWITCH_VIRTUAL_ENV_DIR=".virtualenv"
export AUTOSWITCH_FILE=".venv-autoswitch"

# Load external configs and plugins
for file in $CONFIG_DIR/zsh/autoload/*.zsh; do
  source "$file"
done
if [[ -f $CONFIG_LOCAL_DIR/zsh/autoload/*.zsh ]]; then
  for file in $CONFIG_LOCAL_DIR/zsh/autoload/*.zsh; do
    source "$file"
  done
fi

# Set PATH
source "$CONFIG_DIR/zsh/path.zsh"

# Apply local environment-specific config
# (if fpath is changed in zshrc-after.zsh, compinit might need to be re-run or moved..)
test -f "$CONFIG_LOCAL_DIR/zsh/zshrc-after.zsh" && source "$CONFIG_LOCAL_DIR/zsh/zshrc-after.zsh"

# Enable completions (after zshrc-after.zsh in case `fpath` is changed in local overrides)
autoload -U compinit
compinit

