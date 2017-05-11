# zshrc
# Declares variables and settings useful for any interactive usage of zsh, such
# as prompt, shortcuts, zsh feature settings, etc.

export EDITOR=/usr/local/bin/vim
export CLICOLOR=1
export KEYTIMEOUT=1

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/.cargo/bin:$PATH # toying around with Rust a little lately...
export PATH=$HOME/.bin:$PATH
export PATH=$HOME/.bin/local:$PATH

# I haven't needed JAVA_HOME set lately, but this is where it would be declared
# if I decided to enable it.  This is macOS-specific.
# export JAVA_HOME=`/usr/libexec/java_home`

bindkey -v

autoload -U compinit colors

fpath=($HOME/.zsh/completion $fpath)
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

precmd () { print -Pn "\e]2;%n@%M | ${PWD##*/}\a" } # title bar prompt


# Prevent accidentally entering zsh command mode (execute-named-cmd) when I hit esc
# (https://superuser.com/questions/928846/what-is-execute-on-the-command-line-and-how-to-i-avoid-it)
bindkey -a -r ':'

# aliases for common typos and jump to favorite directories
alias xeit=exit
alias :q=exit
alias cddesktop="cd $HOME/Desktop"
alias cddocuments="cd $HOME/Documents"
alias cddotfiles="cd $HOME/Library/dotfiles"
alias cdnotes="cd $HOME/Documents/notes"

# cd to git root
alias cdgr='git rev-parse && cd "$(git rev-parse --show-cdup)"'

# Source separate file for environment-specific aliases, as these differ between
# work and home.  I probably still need a better approach for separating my
# environment-specific settings.
source $HOME/.zsh_aliases

# Enable various tools
# thefuck is helpful for autocorrecting typos. I add the 'doh' alias to be a
# shade more polite at my shell; YMMV.
eval "$(thefuck --alias)"
alias doh=fuck

# fasd is meant to make switching between directories more convenient.
eval "$(fasd --init auto)"
alias v='f -e vim' # quick opening files with vim

# nvm is a handy thing when I'm actively working with Node on projects, but it
# slows down shell startup (including new tmux splits/windows) noticeably.
# Leaving it commented out for now, might just add latest nvm version of node
# directly to my path.
export NVM_DIR=$HOME/.nvm
# source "/usr/local/opt/nvm/nvm.sh"


# finally, load external configs
for file in $DOTFILE_HOME/zsh/bin/*.zsh; do
  source "$file"
done

if [[ -f "/usr/local/bin/antibody" ]]; then
  source <(antibody init)
  antibody bundle < $DOTFILE_HOME/zsh/plugin-list
fi

