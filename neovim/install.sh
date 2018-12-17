#!/bin/bash

set -e

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source script/logging.sh

NEOVIM_LOCAL="${HOME}/.local/share/nvim"
VIMPLUG_DIR="${NEOVIM_LOCAL}/plugged"
NEOVIM_VENV="${NEOVIM_LOCAL}/venv"
rm -rf "NEOVIM_VENV*"
python3 -m venv "${NEOVIM_VENV}"
"${NEOVIM_VENV}/bin/pip" install neovim

if [ ! -d "${VIMPLUG_DIR}" ]; then
  info "Installing vim-plug from scratch"
  mkdir -p "${NEOVIM_LOCAL}/plugged"
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
success "${VIMPLUG_DIR} is setup"

success "Installing plugins"
nvim --headless \
  +PlugUpgrade \
  +PlugInstall \
  +PlugUpdate \
  +qa!
success "Plugins installed"

info "Setting up backup directory"
mkdir -p "${NEOVIM_LOCAL}/backups"
