#!/bin/sh
for dir in ~/.vim/bundle/*/
do
  cd $dir
  echo "Change to directory: $dir"
  git pull
done

