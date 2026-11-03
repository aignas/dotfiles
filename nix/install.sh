#!/bin/bash
set -euo pipefail

# The initial Home Manager install pulls in a large part of nixpkgs before the
# user configuration (and its nix.settings) exists. Keep it to a single build
# job/core so that it can complete on memory-constrained machines too.
if [[ -z ${NIX_CONFIG:-} ]]; then
    export NIX_CONFIG=$'max-jobs = 1\ncores = 1'
fi

type home-manager >/dev/null || exit 0

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
