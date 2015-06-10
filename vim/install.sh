#!/bin/bash

mkdir -p ~/.vim/bundle

echo "Create backup, swp and undo directories"
mkdir -p ${HOME}/.vim/{backup,swp,undo}
