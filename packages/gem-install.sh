#!/bin/sh

gem install neovim
gem install solargraph

# tmuxinator
gem install tmuxinator
if [[ ! -z "$EXT_REPO_DIR" ]]; then
  mkdir -p "$EXT_REPO_DIR"
  git clone "https://github.com/tmuxinator/tmuxinator" "$EXT_REPO_DIR/tmuxinator"
fi

