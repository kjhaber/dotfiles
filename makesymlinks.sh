#!/bin/sh
# Symlinks dotfiles from this directory to the home directory.
# From http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/

# Back up any existing dotfiles
dir=`pwd`                    # dotfiles directory
olddir=~/dotfiles_old        # old dotfiles backup directory
files="zprofile zshrc zshenv zsh_aliases vimrc tmux.conf gitconfig gitignore_global simplenoterc bin"    # list of files/folders to symlink in homedir

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $files; do
  echo "Moving any existing dotfiles from ~ to $olddir"
  mv ~/.$file ~/dotfiles_old/
  echo "Creating symlink to $file in home directory."
  ln -s $dir/$file ~/.$file
done

