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
helptags) helptags "${2:-}" ;;
reinstall) reinstall ;;
*)
    backupdir
    skk
    ;;
esac
