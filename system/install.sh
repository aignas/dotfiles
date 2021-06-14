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

_setup_deb() {
  sudo apt-get update && \
    \
    env DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
        direnv \
        htop \
        jq \
        less \
        lsof \
        lua5.2 \
        lua5.2-doc \
        lvm2 \
        lynx \
        man-db \
        manpages \
        manpages-dev \
        rsync \
        shellcheck \
        stow \
        texlive \
        texlive-lang-european \
        texlive-latex-extra \
        tmux \
        zsh \
        python3-venv
}

if [ "$(uname -s)" == "Darwin" ]; then
    _setup_mac
    exit 0
fi

_setup_deb
