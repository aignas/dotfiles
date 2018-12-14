#!/bin/bash

NEOVIM_LOCAL="${HOME}/.local/share/nvim"
VIMPLUG_DIR="${NEOVIM_LOCAL}/plugged"

rm -rf "${NEOVIM_LOCAL}/venv*"

if [ ! -d "${VIMPLUG_DIR}" ]; then
  echo "Installing vim-plug from scratch"
  mkdir -p "${NEOVIM_LOCAL}/plugged"
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
echo "${VIMPLUG_DIR} is setup"
nvim \
  +PlugUpgrade \
  +PlugInstall \
  +PlugUpdate \
  +qa!

echo "Setting up backup directory"
mkdir -p "${NEOVIM_LOCAL}/backups"
