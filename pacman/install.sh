#!/bin/bash
set -e

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source script/logging.sh

type pacman >/dev/null || exit 0

_install() {
    local pkgs=(
        adobe-source-han-serif-jp-fonts
        asp
        base-devel
        docker
        ipa-fonts
        nix
        otf-ipaexfont
        python-pillow # required for qmk
        rsync
        rustup
        ttf-hanazono
        ttf-sazanami
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
