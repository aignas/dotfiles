#!/bin/bash

set -e

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
. script/logging.sh

NEOVIM_LOCAL="${HOME}/.local/share/nvim"
NEOVIM_VENV="${NEOVIM_LOCAL}/venv"

pyenv() {
    rm -rf "NEOVIM_VENV*"
    python3 -m venv "${NEOVIM_VENV}"
    "${NEOVIM_VENV}/bin/pip" -q \
        install --upgrade \
        neovim neovim-remote pip setuptools
    ok "python venv: ${NEOVIM_VENV}"
}

update() {
    nvim --headless \
        +PlugUpgrade \
        +PlugUpdate \
        +PlugInstall \
        +PlugClean! \
        +qa!
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
    plug) shift; plug "$@" ;;
    reinstall) reinstall ;;
    *)
        pyenv
        update
        backupdir
        skk
        ;;
esac
