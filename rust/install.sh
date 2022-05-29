#!/bin/bash
set -ex

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs |
    sh -s -- -y --default-toolchain none

source "$HOME/.cargo/env" || :

rustup toolchain install stable beta
rustup component add clippy rustfmt \
    rust-src # needed for rust-analyzer
rustup default stable
rustup update

case $(./bin/dotos) in
    Darwin|"Arch Linux")
        ;;
    *)
        crates=(
            exa
            fd-find
            watchexec-cli
        )
        echo "Installing ${crates[*]} as crates"

        cargo install "${crates[@]}"
        ;;
esac

cargo uninstall https://github.com/jgavris/rs-git-fsmonitor || :
