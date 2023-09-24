#!/bin/bash

type nix-channel >/dev/null || exit 0

nix-channel \
    --add https://github.com/nix-community/home-manager/archive/master.tar.gz \
    home-manager
nix-channel --update

nix-shell '<home-manager>' -A install
