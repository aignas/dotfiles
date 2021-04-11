#!/bin/bash

download() {
    local -r url="https://github.com/${1}/releases/latest/download/${2}.gz"
    local -r dest="${DOTFILES}/tools/${3}"

    if [[ "$url" == *.tar.gz ]]; then
        curl -L "$url" -o - | tar -xvz -C "${DOTFILES}/tools"
    else
        curl -L "$url" -o - | gunzip - >"$dest"
    fi
    chmod +x "$dest"
}

download imsnif/diskonaut diskonaut-0.11.0-unknown-linux-musl.tar diskonaut
download latex-lsp/texlab texlab-x86_64-linux.tar texlab
download rust-analyzer/rust-analyzer rust-analyzer-linux rust-analyzer
download tree-sitter/tree-sitter tree-sitter-linux-x64 tree-sitter
