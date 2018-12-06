#!/bin/bash

echo "The detected OS is ${DOTFILES_OS}"
if [[ ${DOTFILES_OS} == "Mac" ]]; then
    bottles="python3 httpie fd exa ripgrep htop ranger bat zola"
    casks="alacritty"
    brew install "${bottles}"
    brew upgrade "${bottles}"
    brew cask install "${casks}"
    brew cask upgrade "${casks}"
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
        zola \
        skk-jisyo
fi
