#!/bin/bash
set -e

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source script/logging.sh

info "brew"
brew update
ok "brew: update"

brew upgrade
ok "brew: upgrade"

brew tap homebrew/cask-fonts
ok "brew: tap"

debug "brew: install"
brew install --HEAD neovim
brew install \
    coreutils \
    direnv \
    diskonaut \
    exa \
    fd \
    font-hack \
    gh \
    golang \
    htop \
    jq \
    ripgrep \
    rust-analyzer \
    shellcheck \
    stow \
    texlab \
    tig \
    tmux \
    tree-sitter \
    watchman
ok "brew: install"
