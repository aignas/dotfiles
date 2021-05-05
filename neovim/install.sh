#!/bin/bash
set -eu

XDG_DATA_HOME="${XDG_DATA_HOME:-"${HOME}"/.local/share}"
mkdir -p "${XDG_DATA_HOME}"/nvim/{backup,skk}

curl https://skk-dev.github.io/dict/SKK-JISYO.L.gz --location |
    gunzip - >"${XDG_DATA_HOME}/nvim/skk/SKK-JISYO.L"
