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
        eza
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

    # Laptop powersaving
    pkgs+=(
        tlp
        smartmontools
        ethtool
        tp_smapi
    )

    # Steam
    pkgs+=(
        lib32-vulkan-mesa-layers
        pipewire-alsa
        steam-native-runtime
    )

    # Sway
    pkgs+=(
        bemenu-wayland
        brightnessctl
        gammastep
        gnome-keyring
        i3status-rust
        kanshi
        mako
        pamixer
        playerctl
        python-tldextract
        qutebrowser
        spotifyd
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

    # Mail + news
    pkgs+=(
        aerc
        dante
        newsboat
        translate-shell
        w3m
    )

    # Photo
    pkgs+=(
        darktable
        imv
    )

    debug "pacman: install"
    sudo pacman -Syu --noconfirm
    sudo pacman -Sy --needed --noconfirm "${pkgs[@]}"
    ok "pacman: install"
}

_install
