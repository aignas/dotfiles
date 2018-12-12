#!/bin/bash

NEOVIM_LOCAL="${HOME}/.local/share/nvim"
NEOVIM_VENV="${NEOVIM_LOCAL}/venv"
VIMPLUG_DIR="${NEOVIM_LOCAL}/plugged"

rm -rf "${NEOVIM_VENV}"
echo "Setting up python venv: ${NEOVIM_VENV}"
python3 -m venv "${NEOVIM_VENV}"
echo "Updating packages in venv: ${NEOVIM_VENV}"
"${NEOVIM_VENV}/bin/pip" install --upgrade \
  pip \
  setuptools \
  neovim

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

echo "Setting up python backup directory"
mkdir -p "${NEOVIM_LOCAL}/backups"
