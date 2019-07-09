#!/usr/bin/env bash

cd $HOME/ubuntu-config/dotfiles

for filename in `ls -A` ; do
  ln -r -s -f "$filename" ~
done
