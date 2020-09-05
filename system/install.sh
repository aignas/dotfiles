#!/bin/bash
set -e

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source script/logging.sh

DOTFILES_OS="${DOTFILES_OS:-"$(get_os)"}"

echo "The detected OS is ${DOTFILES_OS}"
if [[ ${DOTFILES_OS} == "Debian" ]]; then
    info "apt-get"
    sudo apt-get update
    ok "apt-get: update"

    debug "apt-get: install"
    sudo apt-get install -y \
        jq python3 python3-venv fd-find exa ripgrep htop neovim zsh tmux \
        shellcheck curl unzip golang fonts-firacode kitty

    ok "apt-get: install"
else
    info "Unknown OS"
    ok "Unknown OS: noop"
fi
