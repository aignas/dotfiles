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

debug "brew: install"
brew install --HEAD neovim
brew install \
    coreutils \
    direnv \
    diskonaut \
    exa \
    fd \
    font-hack \
    golang \
    htop \
    jq \
    ripgrep \
    rust-analyzer \
    shellcheck \
    texlab \
    texlive \
    tig \
    tmux \
    tree-sitter \
    watchman

ok "brew: install"
