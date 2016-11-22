#!/bin/sh

if [[ ${DOTFILES_OS} == "Darwin" ]]; then
    brew install task taskd
else
    sudo pacman -S task
fi
