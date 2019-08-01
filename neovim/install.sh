#!/bin/bash

set -e

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
. script/logging.sh

NEOVIM_LOCAL="${HOME}/.local/share/nvim"
NEOVIM_VENV="${NEOVIM_LOCAL}/venv"
plugins=(AndrewRadev/splitjoin.vim \
    autozimu/LanguageClient-neovim \
    junegunn/goyo.vim \
    junegunn/seoul256.vim \
    lotabout/skim \
    lotabout/skim.vim \
    tpope/vim-abolish \
    tpope/vim-eunuch \
    tpope/vim-fugitive \
    tpope/vim-repeat \
    tpope/vim-surround \
    tpope/vim-unimpaired \
    w0rp/ale \
    lervag/vimtex \
    rust-lang/rust.vim \
    tyru/eskk.vim \
    vimwiki/vimwiki)

pyenv() {
    rm -rf "NEOVIM_VENV*"
    python3 -m venv "${NEOVIM_VENV}"
    "${NEOVIM_VENV}/bin/pip" -q \
        install --upgrade \
        neovim neovim-remote pip setuptools
    ok "python venv: ${NEOVIM_VENV}"
}

reinstall() {
    rm -rf "${DOTFILES}/neovim/nvim.xdg/pack"
    git submodule deinit --all -f
    rm "${DOTFILES}/.gitmodules"
    rm -rf "${DOTFILES}/.git/modules/neovim"
    touch "${DOTFILES}/.gitmodules"
    for plugin in "${plugins[@]}"; do
        add "$plugin" &
    done
    wait
}

add() {
    name=${1}
    pname="neovim/plugins/${1}"
    echo "adding $name as $pname"
    wrap git submodule add \
        --name "$pname" \
        "git@github.com:$name" \
        "$(getPath "$name")"
}

getPath() {
    echo "neovim/nvim.xdg/pack/plugins/start/${1/\//-}"
}

update() {
    git submodule update --recursive --remote --jobs=16
    ok "plugins updated"

    runInstall autozimu-LanguageClient-neovim
    helptags
}

runInstall() {
    script="${DOTFILES}/neovim/nvim.xdg/pack/plugins/start/$2/install.sh"
    info "Installing $2..."
    bash -x "$script"
    ok "$2"
}

helptags() {
    for plugin in "${plugins[@]}"; do
        doc="$(getPath "$plugin")/doc"
        [[ ! -d "$doc" ]] && {
            echo "Skipping $doc"
            continue
        }
        nvim --headless +"helptags $doc" +qa! || :
    done
    wait
    ok "help tags updated"
}

backupdir() {
    readonly backup_dir="${NEOVIM_LOCAL}/backup"
    mkdir -p "${backup_dir}"
    ok "backup-dir: ${backup_dir}"
}

skk() {
    target="${NEOVIM_LOCAL}/skk/SKK-JISYO.L"
    rm -rf "${target}.gz" "${target}"
    curl \
        --create-dirs \
        --output "${target}.gz" \
        https://skk-dev.github.io/dict/SKK-JISYO.L.gz
    gunzip "${target}.gz"
    ok "downloading SKK-JISYO.L"
}

case ${1:-} in
    update) update "${2:-}" ;;
    helptags) helptags "${2:-}" ;;
    add) shift; add "$@" ;;
    reinstall) reinstall ;;
    *)
        pyenv
        update
        backupdir
        skk
        ;;
esac
