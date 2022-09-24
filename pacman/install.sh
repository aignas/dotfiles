#!/bin/bash
set -e

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source script/logging.sh

type pacman >/dev/null || exit 0

_install() {
    local pkgs=(
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
        ttf-hanazono
        ttf-sazanami
        watchexec
        xdg-utils
        zsh
    )

    # Steam
    pkgs+=(
        steam-native-runtime
        lib32-vulkan-mesa-layers
    )

    # Sway
    pkgs+=(
        bemenu-wayland
        brightnessctl
        gammastep
        i3status-rust
        kanshi
        mako
        pamixer
        python-tldextract
        qutebrowser
        sway
        swaybg
        swayidle
        swaylock
        ttf-font-awesome
        ttf-hack
        waybar
    )

    # Yubikey
    pkgs+=(
        yubikey-manager
        libfido2
        yubico-pam
    )

    # Mail
    pkgs+=(
        aerc
        dante
        w3m
    )

    debug "pacman: install"
    sudo pacman -Syu --noconfirm
    sudo pacman -Sy --needed --noconfirm "${pkgs[@]}"
    ok "pacman: install"
}

_install
