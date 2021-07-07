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
        neovim \
        netlify-cli \
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

_setup_deb() {
    env DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
        awscli \
        direnv \
        htop \
        jq \
        less \
        rsync \
        shellcheck \
        stow \
        tmux \
        zsh \
        python3-venv
}

if [ "$(uname -s)" == "Darwin" ]; then
    _setup_mac
    exit 0
fi

_setup_deb
