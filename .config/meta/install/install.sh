#!/usr/bin/env zsh
echo 'Fetching kjhaber/dotfiles from github'
git clone --bare https://github.com/kjhaber/dotfiles "$HOME/.config/meta/repo"
alias gitdotfile='git --git-dir=$HOME/.config/meta/repo/ --work-tree=$HOME'
cd "$HOME"
gitdotfile checkout
gitdotfile config --local status.showUntrackedFiles no

echo 'Sourcing zsh configs to trigger install scripts'
source "$HOME/.zshenv"
source "$HOME/.zshrc"

echo 'Installing neovim plugins'
nvim --headless -u "$HOME/.config/nvim/init.vim" -i NONE +PlugInstall +qa\! -- &>/dev/null

echo 'Installing tmux plugins'
$HOME/.tmux/plugins/tpm/bin/install_plugins

echo 'kjhaber/config setup complete.  Restarting zsh is recommended.'

