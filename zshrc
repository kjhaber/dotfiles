# zshrc
# Declares variables and settings useful for any interactive usage of zsh, such
# as prompt, shortcuts, zsh feature settings, etc.

# replace process with nix-env installed zsh version if present
test -f "${DOTFILE_HOME}/zsh/load-from-nix.zsh" && source "${DOTFILE_HOME}/zsh/load-from-nix.zsh"

# local environment-specific config
test -f "${DOTFILE_LOCAL_HOME}/zshrc-local.before" && source "${DOTFILE_LOCAL_HOME}/zshrc-local.before"

export EDITOR=nvim
export CLICOLOR=1
export KEYTIMEOUT=1

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH

# Enable nix package manager if present
test -f "${HOME}/.nix-profile/etc/profile.d/nix.sh" && source "${HOME}/.nix-profile/etc/profile.d/nix.sh"

export PATH=$DOTFILE_HOME/bin:$PATH

# Environment-specific overrides for binaries should come first in PATH
export PATH=$DOTFILE_LOCAL_HOME/bin:$PATH

# Allow environment-specific PATH overrides in dedicated file
test -f "${DOTFILE_LOCAL_HOME}/zshrc-local.path" && source "${DOTFILE_LOCAL_HOME}/zshrc-local.path"

bindkey -v

autoload -U compinit colors

# Use `<ESC>v` to edit current command line in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

fpath=($DOTFILE_HOME/zsh/completion $DOTFILE_LOCAL_HOME/zsh/completion $fpath)
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

source $DOTFILE_HOME/zsh/kjhaber.zsh-theme

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
alias cddotfiles="cd $DOTFILE_HOME"
alias cddotfiles-local="cd $DOTFILE_LOCAL_HOME"
alias cddiary="cd $VIMWIKI_DIARY_DIR"
alias cdnotes="cd $DOC_DIR/notes"

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
# work and home.  I probably still need a better approach for separating my
# environment-specific settings.
test -f "${DOTFILE_LOCAL_HOME}/zshrc-local.aliases" && source "${DOTFILE_LOCAL_HOME}/zshrc-local.aliases"

# Enable various tools

# fzf: fuzzy finder, locate files quickly
# - ctrl-t to insert filename in current command,
# - ctrl-r for recent command history)
export FZF_DEFAULT_COMMAND="rg --files --no-ignore --ignore-case --hidden --follow --glob '!{.git,node_modules,vendor,build,dist}/*'"
export FZF_DEFAULT_OPTS='--color hl:#75a6d6,hl+:#70d4f5'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Taskwarrior
export TASKRC="$DOTFILE_HOME/taskrc"
export TASKDATA="$REMOTE_SYNC_DIR/task"

# Change ssh autocomplete to skip /etc/hosts.  I put hosts entries from
# the blacklist at http://someonewhocares.org/hosts/ into mine, which maps
# a bunch of spam and ad tracker sites to localhost.  This is great for
# privacy and internet performance, but it renders almost all the
# ssh autocomplete values useless.  Values from ~/.ssh/config still work.
zstyle ':completion:*:ssh:*' hosts off

# load external configs and plugins
for file in $DOTFILE_HOME/zsh/bin/*.zsh; do
  source "$file"
done

if [[ -f "/usr/local/bin/antibody" ]]; then
  source <(antibody init)
  antibody bundle < $DOTFILE_HOME/zsh/plugin-list
fi

if [[ -d "$DOTFILE_HOME/zsh/bin/after-plugins" ]]; then
  for file in $DOTFILE_HOME/zsh/bin/after-plugins/*.zsh; do
    source "$file"
  done
fi

# Enable iTerm2 integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# local environment-specific config
test -f "${DOTFILE_LOCAL_HOME}/zshrc-local.after" && source "${DOTFILE_LOCAL_HOME}/zshrc-local.after"

