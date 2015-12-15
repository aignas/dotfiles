#!/bin/bash

NEOVIM_LOCAL=${HOME}/.local/nvim

echo "Install Vim-plug"
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p ${NEOVIM_LOCAL}/plugged

echo "Create backup, swp and undo directories"
mkdir -p ${NEOVIM_LOCAL}/{backup,swp,undo}

echo "In order to make Neovim work with unite and deoplete, one must install"
echo "python-neovim-git from AUR and execute :UpdateRemotePlugins"
