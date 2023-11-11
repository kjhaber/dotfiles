# aliases for common typos and jump to favorite directories
alias xeit=exit
alias :q=exit

# using dash to go up a directory is same as netrw in vim
alias -- -='cd ..'

alias gitdotfile='git --git-dir=$HOME/.config/dotfiles-repo/ --work-tree=$HOME'

# cd to pwd - handy when pwd is log or test dir that is reset by clean/rebuild or deployment
alias cdpwd='cd "$(pwd)"; pwd'

# cd to git root
alias cdgr='git rev-parse && cd "$(git rev-parse --show-cdup)"'

alias vi=nvim
alias vim=nvim
alias vimdiff='nvim -d'

alias tmi='tmuxinator'

alias cdconfig="cd $HOME/.config"
alias cdconfig-local="cd $HOME/.config-local"
alias cddesktop="cd $HOME/Desktop"
alias cddownloads="cd $HOME/Downloads"
alias cddocuments="cd $DOC_DIR"
alias cddiary="cd $VIMWIKI_DIARY_DIR"
alias cdvimwiki="cd $VIMWIKI_DIR"

