#!/bin/bash
set -e

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source script/logging.sh

type apt-get >/dev/null || exit 0

_install() {
    local pkgs=(
        zsh
        aerc
        docker-compose
    )

    # Laptop powersaving
    pkgs+=(
        # todo
    )

    # Steam
    pkgs+=(
    )

    # Sway
    pkgs+=(
        brightnessctl
        bemenu
        fonts-font-awesome
        fonts-hack-ttf
        slurp
        grim
        wl-clipboard
        kanshi
        kanshi
        playerctl
        pulseaudio-utils
        sway
        swayidle
        swaylock
        wev
    )

    # Yubikey
    pkgs+=(
    )

    # Photo
    pkgs+=(
        nsxiv
        imv
        darktable
    )

    debug "apt-get: install"
    sudo apt-get update
    sudo apt-get --yes upgrade
    sudo apt-get install "${pkgs[@]}"
    ok "apt-get: install"
}

_install
