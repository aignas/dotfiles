#!/bin/bash

HOST_OS=$(uname -s)
NEOVIM_LOCAL=${HOME}/.local/share/nvim
NEOVIM_VENV=${NEOVIM_LOCAL}/venv

echo "Installing vim-plug"
mkdir -p ${NEOVIM_LOCAL}/plugged
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Setting up python venv in ${NEOVIM_VENV}"
python3.6 -m venv ${NEOVIM_VENV}
${NEOVIM_VENV}/bin/pip install --upgrade \
    pip \
    setuptools \
    neovim

virtualenv2 ${NEOVIM_VENV}2
${NEOVIM_VENV}2/bin/pip install --upgrade \
    pip \
    setuptools \
    neovim
