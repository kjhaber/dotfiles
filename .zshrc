# zshrc
# Declares variables and settings useful for any interactive usage of zsh, such
# as prompt, shortcuts, zsh feature settings, etc.

# local environment-specific config
test -f "$CONFIG_LOCAL_DIR/zsh/zshrc-before.zsh" && source "$CONFIG_LOCAL_DIR/zsh/zshrc-before.zsh"

export EDITOR=nvim
export CLICOLOR=1
export KEYTIMEOUT=1

# Set PATH
# Allow environment-specific PATH overrides in dedicated file
source "$CONFIG_DIR/zsh/path.zsh"
test -f "$CONFIG_LOCAL_DIR/zsh/path.zsh" && source "$CONFIG_LOCAL_DIR/zsh/path.zsh"

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

source $CONFIG_DIR/zsh/kjhaber.zsh-theme

# title bar prompt
precmd () {
  print -Pn "\e]2;%n@%M | ${PWD##*/}\a" # iterm2 window title
  print -Pn "\e]1;${PWD##*/}\a"         # iterm2 tab title
}


# Prevent accidentally entering zsh command mode (execute-named-cmd) when I hit esc
# (https://superuser.com/questions/928846/what-is-execute-on-the-command-line-and-how-to-i-avoid-it)
bindkey -a -r ':'

# import aliases
source $CONFIG_DIR/zsh/aliases.zsh
test -f "$CONFIG_LOCAL_DIR/zsh/aliases.zsh" && source "$CONFIG_LOCAL_DIR/zsh/aliases.zsh"


# Enable various tools

# fzf: fuzzy finder, locate files quickly
# - ctrl-t to insert filename in current command,
# - ctrl-r for recent command history)
export FZF_DEFAULT_COMMAND="rg --files --no-ignore --ignore-case --hidden --follow --glob '!{.git,node_modules,vendor,build,dist}/*'"
export FZF_DEFAULT_OPTS='--color hl:#75a6d6,hl+:#70d4f5'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Change ssh autocomplete to skip /etc/hosts.  I put hosts entries from
# the blacklist at http://someonewhocares.org/hosts/ into mine, which maps
# a bunch of spam and ad tracker sites to localhost.  This is great for
# privacy and internet performance, but it renders almost all the
# ssh autocomplete values useless.  Values from ~/.ssh/config still work.
zstyle ':completion:*:ssh:*' hosts off

# load external configs and plugins
for file in $CONFIG_DIR/zsh/autoload/*.zsh; do
  source "$file"
done
if [[ -d $CONFIG_LOCAL_DIR/zsh/autoload ]]; then
  for file in $CONFIG_LOCAL_DIR/zsh/autoload/*.zsh; do
    source "$file"
  done
fi

# load zsh plugins
if [[ ! -f $HOME/.zcomet/bin/zcomet.zsh ]]; then
  git clone https://github.com/agkozak/zcomet.git $HOME/.zcomet/bin
fi
source $HOME/.zcomet/bin/zcomet.zsh
source $CONFIG_DIR/zsh/plugins.zsh
test -f "$CONFIG_LOCAL_DIR/zsh/plugins.zsh" && source "$CONFIG_LOCAL_DIR/zsh/plugins.zsh"

# load completions (after plugins)
fpath=($CONFIG_DIR/zsh/completion $CONFIG_LOCAL_DIR/zsh/completion $fpath)
autoload -U compinit
compinit

# local environment-specific config
test -f "$CONFIG_LOCAL_DIR/zsh/zshrc-after.zsh" && source "$CONFIG_LOCAL_DIR/zsh/zshrc-after.zsh"

