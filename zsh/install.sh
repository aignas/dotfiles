#!/bin/bash

if [ "$(uname -s)" != "Darwin" ]; then
    echo "Installing custom term infos for linux terminals to support italics"
    for terminfo in xterm screen; do
        tic "$(dirname $(realpath $0))/terminfos/$terminfo-256color-italic.terminfo"
    done
fi

echo "Setting up Zprezto"
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

echo "Downloading Base16"
TARGET_BASE16_DIR="${HOME}/src/github/base16"
if [ -d ${TARGET_BASE16_DIR}/base16-builder ]; then
    cd ${TARGET_BASE16_DIR}/base16-builder
    git pull
    git submodule update --init --recursive
    cd -
else
    GIT_REPO="https://github.com/chriskempson/base16-builder.git"
    git clone ${GIT_REPO} ${TARGET_BASE16_DIR}/base16-builder

fi

echo "Generating the themes"
cd ${TARGET_BASE16_DIR}/base16-builder
./base16 > /dev/null
cd -
