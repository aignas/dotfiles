#!/bin/bash

type nix-channel >/dev/null || exit 0

nix-channel \
    --add https://github.com/nix-community/home-manager/archive/master.tar.gz \
    home-manager
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update

nix-shell '<home-manager>' -A install
mkdir -p ~/.config/home-manager
pushd ~/.config/home-manager
rm home.nix
ln -s ~/.dotfiles/nix/home.nix
popd
