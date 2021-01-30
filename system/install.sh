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
    font-hack

ok "apt-get: install"
