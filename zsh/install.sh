#!/bin/bash

if [ "$(uname -s)" != "Darwin" ]; then
    echo "Installing custom term infos for linux terminals to support italics"
    for terminfo in xterm screen; do
        tic "$(dirname $(realpath $0))/terminfos/$terminfo-256color-italic.terminfo"
    done
fi

echo "Setting up Zprezto"
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
