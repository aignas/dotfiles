#!/bin/bash

echo "Setting up Zgen"
mkdir -p "${HOME}/src/github/zgen"
git clone https://github.com/tarjoilija/zgen.git "${HOME}/src/github/zgen"

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
