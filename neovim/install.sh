#!/bin/bash

set -e

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
. script/logging.sh

NEOVIM_LOCAL="${HOME}/.local/share/nvim"

pyenv() {
    pip3 install --user pynvim
    ok "pynvim"
}

update() {
    ./neovim/vim-plugr.sh
    ok "update"
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

plug() {
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ok "plug"
}

case ${1:-} in
update) update "${2:-}" ;;
helptags) helptags "${2:-}" ;;
plug)
    shift
    plug "$@"
    ;;
reinstall) reinstall ;;
*)
    plug
    update
    backupdir
    skk
    ;;
esac
