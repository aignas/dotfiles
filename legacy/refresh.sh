#!/bin/bash
set -euo pipefail

link() {
    local -r src="../$1"
    local -r dest=".$(basename "${1/dot-/}")"
    rm "$dest"

    echo "Linking '$src'to '$dest'"
    ln -s "$src" "$dest"
}

link git/dot-gitconfig
link stow/dot-stow-global-ignore
link stow/dot-stowrc
link tmux/dot-tmux.conf
link tmux/dot-tmux
link zsh/dot-zshrc
