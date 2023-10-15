#!/bin/bash
set -eu

XDG_DATA_HOME="${XDG_DATA_HOME:-"${HOME}"/.local/share}"
mkdir -p "${XDG_DATA_HOME}"/nvim/{backup,skk}

# TODO @aignas 2023-10-15: use home-manager fetchTarball function to download
# and extract this.
curl https://skk-dev.github.io/dict/SKK-JISYO.L.gz --location |
    gunzip - >"${XDG_DATA_HOME}/nvim/skk/SKK-JISYO.L"
