#!/bin/bash

NEOVIM_LOCAL=${HOME}/.local/nvim

echo "Install NeoBundle"
mkdir -p ${NEOVIM_LOCAL}/bundle
NEOBUNDLE_REPO="https://github.com/Shougo/neobundle.vim"
git clone ${NEOBUNDLE_REPO} ${NEOVIM_LOCAL}/bundle/neobundle.vim

echo "Create backup, swp and undo directories"
mkdir -p ${NEOVIM_LOCAL}/{backup,swp,undo}
