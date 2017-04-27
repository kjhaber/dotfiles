export EDITOR=/usr/local/bin/vim
export CLICOLOR=1
export HOMEBREW_NO_ANALYTICS=1

export JAVA_HOME=`/usr/libexec/java_home`
export DOTFILE_HOME="~/Library/dotfiles"

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/share/npm/bin:$PATH
export PATH=$JAVA_HOME/bin:$PATH
export PATH=~/.cargo/bin:$PATH
export PATH=~/.bin:$PATH

alias xeit=exit
alias :q=exit
alias cddesktop="cd ~/Desktop"
alias cddotfiles="cd ~/Library/dotfiles"
alias cdnotes="cd ~/Documents/notes"

# cd to git root
alias cdgr='git rev-parse && cd "$(git rev-parse --show-cdup)"'

eval "$(thefuck --alias)"
alias doh=fuck

eval "$(fasd --init auto)"
alias v='f -e vim' # quick opening files with vim

export NVM_DIR=~/.nvm
. "/usr/local/opt/nvm/nvm.sh"

. ~/.zsh_aliases

