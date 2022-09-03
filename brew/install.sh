#!/bin/bash
set -e

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source script/logging.sh

type brew >/dev/null || exit 0

_install() {
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
        rustup-init
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

_install
