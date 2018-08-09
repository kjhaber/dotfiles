# cdfzf.zsh
#
# Function for creating aliases to cd into a child directory of a root path
# using fzf fuzzy matching.  https://github.com/junegunn/fzf
#
# Note that this needs to be a zsh function instead of a plain shell script.
# Otherwise the script will cd to the new directory in a subshell and exit,
# leaving you where you started.
#
# Arg 1: Root directory
# Arg 2: Max subdirectory depth (default 1)
#
# Example:
# cdfzf ~/Documents 2

function cdfzf() {

  # $1 is the root directory.  if path is relative to ~ shorthand, expand to $HOME
  ROOT_DIR=$(sed -e "s|^\~\/|$HOME/|g" <<< "$1")

  # if no root dir provided, exit
  if [ -z "$ROOT_DIR" ] ; then
    echo "Usage: cdfzf <root_dir> <max_subdir_depth>"
    return 1
  fi

  # handle special case of '~' only
  if [ "$ROOT_DIR" = '~' ] ; then
    ROOT_DIR="$HOME"
  fi

  # $2 is selectable subdirectory depth.  default is 1 (seems like a sane default)
  MAX_SUBDIR_DEPTH="$2"
  if [ -z "$MAX_SUBDIR_DEPTH" ] ; then
    MAX_SUBDIR_DEPTH=1
  fi

  # find list of subdirectories of ROOT_DIR.
  # the sed command removes ROOT_DIR from the options shown during fuzzy select
  ROOT_SUBDIR_LIST=$( \
      find -L "$ROOT_DIR" -type d -maxdepth "$MAX_SUBDIR_DEPTH" | \
      sed -e "s|^$ROOT_DIR||g" -e "s|^/||g" \
    )

  # strip out hidden directories.  maybe make this conditional later
  ROOT_SUBDIR_LIST=$( grep -v -E '(^\.)|(\/\.)' <<< "$ROOT_SUBDIR_LIST" )

  # fuzzy-seelct from list of subdirectories
  # the bare 'echo' adds an empty element to allow selecting the root dir itself
  ROOT_SUBDIR=$( {echo "$ROOT_SUBDIR_LIST" ; echo } | fzf-tmux --no-multi -r )

  # if fzf did not exit normally, don't change directory
  if [ $? -ne 0 ] ; then
    return 1
  fi

  # change to selected directory and output new location
  cd "$ROOT_DIR/$ROOT_SUBDIR" || return 1
  pwd
}

