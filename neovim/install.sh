#!/bin/bash

HOST_OS=$(uname -s)
VIM_LOCAL=${HOME}/.vim
NEOVIM_LOCAL=${HOME}/.local/nvim
NEOVIM_VENV=${NEOVIM_LOCAL}/venv

echo "Install Vim-plug"
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Setting venv for use with neovim"
mkdir -p ${NEOVIM_LOCAL}/plugged

echo "Create backup, swp and undo directories.  Shared with vim."
mkdir -p ${VIM_LOCAL}/{backup,swp,undo}

echo "Installing Mono"
echo "Visit http://www.mono-project.com/download/"
read "Press [Enter] to contitue"

echo "Setting up python"
pyvenv ${NEOVIM_VENV}
${NEOVIM_VENV}/bin/pip install --upgrade \
    pip \
    setuptools \
    neovim

# This is only needed because of the omnisharp plugin
python2 -m pip install virtualenv
python2 -m virtualenv ${NEOVIM_VENV}2
${NEOVIM_VENV}2/bin/pip install --upgrade \
    pip \
    setuptools \
    tasklib \
    neovim

${NEOVIM_VENV}2/bin/pip install --upgrade \
    git+git://github.com/tbabej/tasklib@develop

nvim +PlugInstall +UpdateRemotePlugins +qall
