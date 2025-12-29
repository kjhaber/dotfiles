if [[ ! -f $HOME/.zcomet/bin/zcomet.zsh ]]; then
  git clone https://github.com/agkozak/zcomet.git $HOME/.zcomet/bin
fi
source $HOME/.zcomet/bin/zcomet.zsh

# Load zsh plugins
source $CONFIG_DIR/zsh/plugins.zsh
test -f "$CONFIG_LOCAL_DIR/zsh/plugins.zsh" && source "$CONFIG_LOCAL_DIR/zsh/plugins.zsh"
