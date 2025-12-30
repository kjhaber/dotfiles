if [[ ! -d  "$HOME/.fzf" ]]; then
  echo "Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all --key-bindings --completion --no-update-rc --no-bash --no-zsh
  echo "Done"
fi

# Enable fzf: fuzzy finder, locate files quickly
# - ctrl-t to insert filename in current command,
# - ctrl-r for recent command history)
export FZF_DEFAULT_COMMAND="rg --files --no-ignore --ignore-case --hidden --follow --glob '!{.git,node_modules,vendor,build,dist}/*'"
export FZF_DEFAULT_OPTS='--color hl:#75a6d6,hl+:#70d4f5'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

