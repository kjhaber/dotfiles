export EDITOR=/usr/local/bin/vim
export CLICOLOR=1
export HOMEBREW_NO_ANALYTICS=1

export JAVA_HOME=`/usr/libexec/java_home`
export DOTFILE_HOME="~/Library/dotfiles"

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/share/npm/bin:$PATH
export PATH=$JAVA_HOME/bin:$PATH
export PATH=~/.bin:$PATH

alias xeit=exit
alias :q=exit
alias cddesktop="cd ~/Desktop"
alias cddotfiles="cd ~/Library/dotfiles"

eval "$(thefuck --alias)"
alias doh=fuck

. ~/.zsh_aliases

