# zshrc
# Declares variables and settings useful for any interactive usage of zsh, such
# as prompt, shortcuts, zsh feature settings, etc.

# Startup profiling - enable with: ZSH_PROFILE_STARTUP=1 zsh -i -c exit
# Or use: zsh-startup-profile
if [[ -n "$ZSH_PROFILE_STARTUP" ]]; then
  zmodload zsh/zprof
  zmodload zsh/datetime
  _zsh_profile_start=$EPOCHREALTIME
  # Override source to time each file
  function source() {
    local _t0=$EPOCHREALTIME
    builtin source "$@"
    printf "%6.0fms  source %s\n" "$(( (EPOCHREALTIME - _t0) * 1000 ))" "$1"
  }
fi

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
HISTSIZE=1000000000
SAVEHIST=1000000000
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


# zsh-autoswitch-virtualenv options
export AUTOSWITCH_DEFAULT_PYTHON="$HOME/.local/share/mise/shims/python"
export AUTOSWITCH_VIRTUAL_ENV_DIR=".virtualenv"
export AUTOSWITCH_FILE=".venv-autoswitch"

# Set PATH first so autoload files can rely on $HOMEBREW_PREFIX and other vars
source "$CONFIG_DIR/zsh/path.zsh"

# Load external configs and plugins
for file in $CONFIG_DIR/zsh/autoload/*.zsh; do
  source "$file"
done
if [[ -f $CONFIG_LOCAL_DIR/zsh/autoload/*.zsh ]]; then
  for file in $CONFIG_LOCAL_DIR/zsh/autoload/*.zsh; do
    source "$file"
  done
fi

# Apply local environment-specific config
# (if fpath is changed in zshrc-after.zsh, compinit might need to be re-run or moved..)
test -f "$CONFIG_LOCAL_DIR/zsh/zshrc-after.zsh" && source "$CONFIG_LOCAL_DIR/zsh/zshrc-after.zsh"

# Enable completions (after zshrc-after.zsh in case `fpath` is changed in local overrides)
# Use compinit -C (skip security audit) when dump is <20h old — much faster.
# To force a full refresh: zsh-completion-refresh
autoload -U compinit
typeset -a _zcompdump_recent
_zcompdump_recent=(~/.zcompdump(Nmh-20))
if (( ${#_zcompdump_recent} )); then
  compinit -C
else
  compinit
fi
unset _zcompdump_recent

if [[ -n "$ZSH_PROFILE_STARTUP" ]]; then
  unfunction source 2>/dev/null  # restore built-in source
  zprof
  printf "Total startup: %.0fms\n" "$(( (EPOCHREALTIME - _zsh_profile_start) * 1000 ))"
fi
