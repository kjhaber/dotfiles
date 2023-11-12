#!/usr/bin/env zsh

echo 'Fetching kjhaber/config from github'
git clone --bare https://github.com/kjhaber/config "$HOME/.config/meta/repo"
alias gitdotfile='git --git-dir=$HOME/.config/meta/repo/ --work-tree=$HOME'
cd "$HOME"
gitdotfile checkout
gitdotfile config --local status.showUntrackedFiles no

echo 'Sourcing zsh configs to trigger install scripts'
source "$HOME/.zshenv"
source "$HOME/.zshrc" # trigger install scripts in .config/zsh

echo 'Installing tmux plugins'
$HOME/.tmux/plugins/tpm/bin/install_plugins

echo 'Installing neovim plugins'
nvim -es -u "$HOME/.config/nvim/init.vim" -i NONE -c "PlugInstall" -c "qa"

echo 'kjhaber/config setup complete.  Restarting zsh is recommended.'

