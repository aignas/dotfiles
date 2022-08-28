#!/bin/bash
set -e

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source script/logging.sh

type apt-get >/dev/null || exit 0

_install() {
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

_install
