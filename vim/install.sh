#!/bin/bash

VIM_DATA=${HOME}/.vim

echo "Install Vim-plug"
curl -fLo ${VIM_DATA}/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Create backup, swp and undo directories"
mkdir -p ${VIM_DATA}/{backup,swp,undo}
