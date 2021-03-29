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

download() {
    local -r url="https://github.com/${1}/releases/latest/download/${2}.gz"
    local -r dest="${DOTFILES}/tools/${3}"

    curl -L "$url" -o - | gunzip - >"$dest"
    chmod +x "$dest"
}

download rust-analyzer/rust-analyzer rust-analyzer-linux rust-analyzer
download tree-sitter/tree-sitter tree-sitter-linux-x64 tree-sitter
