AWS_ZSH_AUTOCOMPLETER=$(source "$DOTFILE_HOME/zsh/bin/find-aws-cli-autocomplete.sh")
if [ -n "$AWS_ZSH_AUTOCOMPLETER" ]; then
  source "$AWS_ZSH_AUTOCOMPLETER"
fi

