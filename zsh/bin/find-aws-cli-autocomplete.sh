#!/bin/sh

AWS_COMPLETER_SYMLINK=$(command -v -- aws_completer)
if [ -n "$AWS_COMPLETER_SYMLINK" ]; then
  AWS_COMPLETER_SYMLINK_DIR=$(dirname "$AWS_COMPLETER_SYMLINK")
  cd "$AWS_COMPLETER_SYMLINK_DIR" || exit
  AWS_COMPLETER_REAL=$(realpath "$(readlink "$AWS_COMPLETER_SYMLINK")")
  AWS_COMPLETER_REAL_DIR=$(dirname "$AWS_COMPLETER_REAL")
  AWS_ZSH_COMPLETER="$AWS_COMPLETER_REAL_DIR/aws_zsh_completer.sh"

  echo "$AWS_ZSH_COMPLETER"
fi

