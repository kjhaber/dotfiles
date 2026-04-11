# aliases for common typos and jump to favorite directories
alias xeit=exit
alias :q=exit

# using dash to go up a directory is same as netrw in vim
alias -- -='cd ..'

alias gitdotfile='git --git-dir=$HOME/.config/meta/repo/ --work-tree=$HOME'

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
alias cddotfiles="cdfzf $HOME/.config 2"
alias cddotfiles-local="cdfzf $HOME/.config-local 2"
alias cddesktop="cd $HOME/Desktop"
alias cddownloads="cd $HOME/Downloads"
alias cddocuments="cd $DOC_DIR"
alias cddiary="cd $VIMWIKI_DIARY_DIR"
alias cdvimwiki="cd $VIMWIKI_DIR"

alias wnv="wn verify"

# Rebuild zsh completion cache. Use this when developing/testing completion scripts
# or after installing a new tool with completions.
function zsh-completion-refresh() {
  rm -f ~/.zcompdump*
  autoload -U compinit && compinit
  echo "Completions refreshed. Run 'exec zsh' if changes don't take effect."
}

# Clear all zsh startup caches (brew-env, go-env, mise package merge sentinel).
# Use this after a brew upgrade, Go upgrade, or if startup behavior seems stale.
# Also clears completion cache. Run 'exec zsh' afterward to rebuild.
function zsh-cache-refresh() {
  echo "Clearing zsh startup caches..."
  rm -f ~/.cache/zsh/*.zsh ~/.cache/mise/.last-merge ~/.zcompdump*(N)
  echo "All caches cleared. Run 'exec zsh' to rebuild."
}
