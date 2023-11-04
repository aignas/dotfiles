#!/bin/bash
set -euo pipefail

type nix-channel >/dev/null || exit 0

if ! type home-manager >/dev/null; then
    nix-channel \
        --add https://github.com/nix-community/home-manager/archive/master.tar.gz \
        home-manager
    nix-channel --add https://nixos.org/channels/nixpkgs-unstable
fi
nix-channel --update
# We need to only do an initial install as home-manager can manage itself
type home-manager >/dev/null || nix-shell '<home-manager>' -A install

mkdir -p ~/.config/home-manager
pushd ~/.config/home-manager
rm home.nix
ln -s ~/.dotfiles/nix/home.nix .
popd
