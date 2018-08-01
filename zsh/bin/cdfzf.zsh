# cdfzf.zsh
#
# Function for creating aliases to cd into a child directory of a root path
# using fzf fuzzy matching.  https://github.com/junegunn/fzf 
#
# Example:
# cdfzf ~/Documents 2

function cdfzf() {
  ROOT_DIR=$1
  MAX_DEPTH=$2
  cd $ROOT_DIR/$((find $ROOT_DIR -type d -maxdepth $MAX_DEPTH ; echo) | fzf --no-multi | sed "s|^$ROOT_DIR/||g") ; pwd
}

