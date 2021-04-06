#!/bin/bash
set -ex

if [[ ! -f "$(command -v rustup)" ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

rustup toolchain install stable beta
rustup component add clippy rustfmt \
    rust-src # needed for rust-analyzer
rustup default stable
rustup update

cargo install watchexec
cargo install --git=https://github.com/jgavris/rs-git-fsmonitor.git
