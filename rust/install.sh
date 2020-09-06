#!/bin/bash

if [[ ! -f "$(command -v rustup)" ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

rustup toolchain install stable beta
rustup component add clippy rustfmt rls
rustup default stable
rustup update

cargo install watchexec
