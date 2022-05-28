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
        autossh \
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
        k3d \
        neovim \
        netlify-cli \
        npm \
        ripgrep \
        rs-git-fsmonitor \
        rust-analyzer \
        saml2aws \
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
    sudo add-apt-repository ppa:neovim-ppa/stable

    env DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
        awscli \
        direnv \
        htop \
        jq \
        less \
        python-is-python3 \
        python3-venv \
        rsync \
        shellcheck \
        stow \
        tmux \
        watchman \
        zsh
}

_setup_arch() {
    sudo pacman -S \
        base-devel
        direnv \
        htop \
        jq \
        rsync \
        shellcheck \
        stow \
        tmux \
        zsh
}


case "$(uname -a)" in
    Darwin*)
        _setup_mac
        ;;
    Linux*arch*)
        _setup_arch
        ;;
    *)
        _setup_deb
        ;;
esac
