#!/bin/bash
set -e

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

download() {
    local -r url="https://github.com/${1}/releases/latest/download/${2}"
    local -r dest="tools/${3:-$2}"

    curl -L "$url" -o "$dest" && chmod +x "$dest"
}

download rust-analyzer/rust-analyzer rust-analyzer-linux rust-analyzer
