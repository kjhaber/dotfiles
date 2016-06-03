#!/bin/sh
for dir in ~/.vim/bundle/*/
do
  cd $dir
  echo `git ls-remote --get-url`
done

