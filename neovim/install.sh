#!/bin/bash

set -e

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
. script/logging.sh

XDG_DATA_HOME="${XDG_DATA_HOME:-"${HOME}"/.local/share}"

backupdir() {
    readonly backup_dir="${XDG_DATA_HOME}/nvim/backup"
    mkdir -p "${backup_dir}"
    ok "backup-dir: ${backup_dir}"
}

skk() {
    target="${XDG_DATA_HOME}/nvim/skk/SKK-JISYO.L"
    rm -rf "${target}.gz" "${target}"
    curl \
        --create-dirs \
        --output "${target}.gz" \
        --location \
        https://skk-dev.github.io/dict/SKK-JISYO.L.gz
    gunzip "${target}.gz"
    ok "downloading SKK-JISYO.L"
}

case ${1:-} in
*)
    backupdir
    skk
    ;;
esac
