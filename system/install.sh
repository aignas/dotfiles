#!/bin/bash
set -e

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source script/logging.sh

_setup_mac() {
    info "brew"
    brew update
    ok "brew: update"

    brew upgrade
    ok "brew: upgrade"

    brew tap homebrew/cask-fonts
    brew tap jgavris/rs-git-fsmonitor https://github.com/jgavris/rs-git-fsmonitor.git
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
        npm \
        ripgrep \
        rs-git-fsmonitor \
        rust-analyzer \
        shellcheck \
        stow \
        texlab \
        tig \
        tmux \
        tree-sitter \
        watchexec \
        watchman \
        zola
    ok "brew: install"
}

if [ "$(uname -s)" == "Darwin" ]; then
    _setup_mac
    return
fi
