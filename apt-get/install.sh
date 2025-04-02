#!/bin/bash
set -e

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source script/logging.sh

type apt-get >/dev/null || exit 0

_install() {
    local pkgs=(
        rustup
        zsh
    )

    # Laptop powersaving
    pkgs+=(
        tp_smapi
    )

    # Steam
    pkgs+=(
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

    debug "apt-get: install"
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install "${pkgs[@]}"
    ok "apt-get: install"
}

_install
