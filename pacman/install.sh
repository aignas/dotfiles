#!/bin/bash
set -e

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source script/logging.sh

type pacman >/dev/null || exit 0

_install() {
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
        # Steam
        steam-native-runtime
        lib32-vulkan-mesa-layers
        # Sway
        bemenu-wayland
        brightnessctl
        gammastep
        i3status
        kanshi
        mako
        pamixer
        python-tldextract
        qutebrowser
        sway
        swaybg
        swayidle
        swaylock
        waybar
    )

    debug "pacman: install"
    sudo pacman -Sy --needed --noconfirm "${pkgs[@]}"
    ok "pacman: install"
}

_install
