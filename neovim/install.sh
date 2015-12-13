#!/bin/bash

NEOVIM_LOCAL=${HOME}/.local/nvim

echo "Install Vim-plug"
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p ${NEOVIM_LOCAL}/plugged

echo "Create backup, swp and undo directories"
mkdir -p ${NEOVIM_LOCAL}/{backup,swp,undo}
