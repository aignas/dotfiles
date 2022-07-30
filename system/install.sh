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
    local -r pkgs=(
        autossh
        coreutils
        direnv
        diskonaut
        exa
        fd
        font-hack
        gh
        golang
        htop
        jq
        k3d
        neovim
        npm
        ripgrep
        rs-git-fsmonitor
        rust-analyzer
        saml2aws
        shellcheck
        stow
        texlab
        tig
        tmux
        tree-sitter
        watchexec
        zola
    )

    brew install "${pkgs[@]}"
    ok "brew: install"
}

_setup_deb() {
    sudo add-apt-repository ppa:neovim-ppa/stable

    local -r pkgs=(
        awscli
        direnv
        htop
        jq
        less
        python-is-python3
        python3-venv
        rsync
        shellcheck
        stow
        tmux
        zsh
    )

    debug "apt-get: install"
    env DEBIAN_FRONTEND=noninteractive sudo apt-get install -y "${pkgs[@]}"
    ok "apt-get: install"
}

_setup_arch() {
    local -r pkgs=(
        asp
        base-devel
        direnv
        diskonaut
        docker
        exa
        fd
        github-cli
        htop
        jq
        jq
        npm
        otf-ipaexfont
        python-pre-commit
        python-pillow # required for qmk
        ripgrep
        rsync
        rustup
        shellcheck
        stow
        tig
        tmux
        ttf-hack
        ttf-hanazono
        ttf-sazanami
        watchexec
        xdg-utils
        zsh
    )

    debug "pacman: install"
    sudo pacman -S --needed --noconfirm "${pkgs[@]}"
    ok "pacman: install"
}


case "$(./bin/dotos)" in
    Mac)
        _setup_mac
        ;;
    "Arch Linux")
        _setup_arch
        ;;
    Ubuntu)
        _setup_deb
        ;;
esac
