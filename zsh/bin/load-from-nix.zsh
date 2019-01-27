# Loads updated version of zsh installed in ~/.nix-profile if present.
# This allows me to use a current version of zsh on certain work machines where
# I can install nix package manager (https://nixos.org/nix/) but can't easily
# change my login shell.

ZSH=$HOME/.nix-profile/bin/zsh
if [[ $SHELL != $ZSH && -e $ZSH ]]
then
  SHELL=$ZSH
  # -$- passes all options for the current shell to the replacement shell
  # being exec'd, and $@ passes the rest of the command line args in.
  exec $ZSH -$- "$@"
fi

