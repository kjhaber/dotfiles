# zshrc
# Declares variables and settings useful for any interactive usage of zsh, such
# as prompt, shortcuts, zsh feature settings, etc.

# local environment-specific config
test -f "$HOME/zsh/zshrc-local.before" && source "$HOME/zsh/zshrc-local.before"

export EDITOR=nvim
export CLICOLOR=1
export KEYTIMEOUT=1

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH

# Enable nix package manager if present
test -f "$HOME/.nix-profile/etc/profile.d/nix.sh" && source "$HOME/.nix-profile/etc/profile.d/nix.sh"

export PATH=$DOTFILE_HOME/bin:$PATH

# Environment-specific overrides for binaries should come first in PATH
export PATH=$DOTFILE_LOCAL_HOME/bin:$PATH

# Allow environment-specific PATH overrides in dedicated file
test -f "$CONFIG_DIR/zsh/zshrc-local.path" && source "$CONFIG_DIR/zsh/zshrc-local.path"

bindkey -v

autoload -U compinit colors

# Use `<ESC>v` to edit current command line in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

fpath=($CONFIG_DIR/zsh/completion $DOTFILE_LOCAL_HOME/zsh/completion $fpath)
compinit
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

alias vi=nvim
alias vim=nvim
alias vimdiff='nvim -d'

# aliases for common typos and jump to favorite directories
alias xeit=exit
alias :q=exit

# using dash to go up a directory is same as netrw in vim
alias -- -='cd ..'

# cd to pwd - handy when pwd is log or test dir that is reset by clean/rebuild or deployment
alias cdpwd='cd "$(pwd)"; pwd'

alias cddesktop="cd $HOME/Desktop"
alias cddownloads="cd $HOME/Downloads"
alias cddocuments="cd $DOC_DIR"
alias cddiary="cd $VIMWIKI_DIARY_DIR"
alias cdvimwiki="cd $VIMWIKI_DIR"

alias gitdotfile='/usr/local/bin/git --git-dir ~/.config/dotfiles-repo/ --work-tree=$HOME'
alias gitdotfile-local='/usr/local/bin/git --git-dir ~/.config/dotfiles-local-repo/ --work-tree=$HOME'

# Maven
alias mci="mvn clean install"
alias mcp="mvn clean package"
alias mcsr="mvn clean spring-boot:run"
alias mvn-clean-all='find . -name "pom.xml" -execdir mvn clean \;'

# GraalVM + Maven
alias gmci="gmvn clean install"
alias gmcp="gmvn clean package"

# cd to git root
alias cdgr='git rev-parse && cd "$(git rev-parse --show-cdup)"'

alias tmi='tmuxinator'

# Source separate file for environment-specific aliases, as these differ between
# work and home machines
test -f "$CONFIG_DIR/zsh/zshrc-local.aliases" && source "$CONFIG_DIR/zsh/zshrc-local.aliases"

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
for file in $CONFIG_DIR/zsh/bin/*.zsh; do
  source "$file"
done

# load zsh plugins
if [[ ! -f $HOME/.zcomet/bin/zcomet.zsh ]]; then
  git clone https://github.com/agkozak/zcomet.git $HOME/.zcomet/bin
fi
source $HOME/.zcomet/bin/zcomet.zsh
zcomet load zsh-users/zsh-autosuggestions
zcomet load zsh-users/zsh-syntax-highlighting
zcomet load kjhaber/cdfzf.zsh
zcomet load kjhaber/tm.zsh

# Enable iTerm2 integration
test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"

# local environment-specific config
test -f "$DOTFILE_LOCAL_HOME/zshrc-local.after" && source "$DOTFILE_LOCAL_HOME/zshrc-local.after"

