#!/bin/bash

echo "The detected OS is ${DOTFILES_OS}"
if [[ ${DOTFILES_OS} == "Mac" ]]; then
    brew install python3 httpie fd exa ripgrep htop ranger bat
    brew cask install alacritty
elif [[ ${DOTFILES_OS} == "ArchLinux" ]]; then
    sudo pacman -Sy --needed \
        httpie \
        python \
        neovim \
        ranger \
        fd exa ripgrep bat \
        alacritty \
        htop \
        dep \
        skk-jisyo
fi
