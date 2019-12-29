#!/bin/bash

set -euo pipefail

readonly DEST="${HOME}/.local/share/nvim/site/pack/plugr/start/"

github_install() {
    remote=$1
    treeish=$2
    dest=$3
    zip="/tmp/$remote.zip"
    curl \
        -L0 \
        --create-dirs \
        --output "$zip.zip" \
        --silent \
        "https://github.com/$remote/archive/$treeish.zip"
    mkdir -p "$(dirname "$dest")"
    unzip -o -qq "$zip.zip" -d "$zip"
    mv "$zip/$(basename "$remote")-$treeish" "$dest"
    rm "$zip.zip"
    rmdir "$zip"

    # Remove git-related files to prevent nested git repositories
    rm -rf "$dest"/.git*

    # Remove any non-essential files that are not needed for the plugin to run
    rm -rf "$dest"/README*
    rm -f "$dest"/*.{md,mdown,mkdown,markdown}
    rm -rf "$dest"/test
    echo "Downloading $1... DONE"
}

Plug() {
    treeish="master"
    dest="${DEST}/$(basename "$1")"
    cmd=""
    plugin=""

    while [[ $# -gt 0 ]]; do
        key="$1"

        case $key in
        --dir)
            if [[ -L $2 ]]; then
                rm "$2"
            fi
            ln -s "$dest" "$2" # make a symbolic link to the main directory
            shift
            shift
            ;;
        --branch)
            treeish="$2"
            shift
            shift
            ;;
        --do)
            cmd="$2"
            shift
            shift
            ;;
        *)
            plugin="$1"
            shift
            ;;
        esac
    done

    {
        rm -rf "$dest"
        github_install "$plugin" "$treeish" "$dest"
        [[ -n "${cmd}" ]] && {
            echo "Running post install hook for $plugin..."
            cd "$dest"
            output="$($cmd 2>&1)"
            echo -e "$plugin post install output\n$output"
        }
    } &
}

rm -rf "${DEST}"
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/fzf' \
    --dir ~/.fzf \
    --do './install --all'
Plug 'junegunn/fzf.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'cappyzawa/starlark.vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'dense-analysis/ale'
Plug 'joereynolds/vim-minisnip'
Plug 'vimwiki/vimwiki'
Plug 'lervag/vimtex'
Plug 'rust-lang/rust.vim'
Plug 'arp242/gopher.vim'
Plug 'tyru/eskk.vim'
Plug 'autozimu/LanguageClient-neovim' \
    --branch 'next' \
    --do './install.sh'
# Plug 'euclio/vim-markdown-composer' \
#     --do 'cargo build --release --locked'

wait

nvim --headless +"helptags ALL" +qa! || :
