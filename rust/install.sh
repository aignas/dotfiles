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

if [ "$(uname -s)" == "Darwin" ]; then
    exit 0
fi

crates=(
    exa
    fd-find
    watchexec-cli
)

cargo install "${crates[@]}"
cargo install --git https://github.com/jgavris/rs-git-fsmonitor
