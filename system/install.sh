#!/bin/bash
set -e

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source script/logging.sh

info "apt-get"
sudo apt-get update
ok "apt-get: update"

debug "apt-get: install"
sudo apt-get install -y \
    jq python3 python3-venv fd-find exa ripgrep htop neovim zsh tmux \
    shellcheck curl unzip golang fonts-firacode direnv watchman tig \
    fonts-hack gimp inkscape lua5.1 liblua5.1 texlive

ok "apt-get: install"
