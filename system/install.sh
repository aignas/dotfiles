#!/bin/sh

readonly common="httpie fd exa ripgrep bat htop neovim ranger zola zsh"

echo "The detected OS is ${DOTFILES_OS}"
if [[ ${DOTFILES_OS} == "Mac" ]]; then
    bottles="python3 ${common}"
    casks="alacritty font-hack"
    brew install "${bottles}"
    brew upgrade "${bottles}"
    brew tap homebrew/cask-fonts
    brew cask install "${casks}"
    brew cask upgrade "${casks}"
elif [[ ${DOTFILES_OS} == "ArchLinux" ]]; then
    sudo pacman -Sy --needed \
        python $common \
        alacritty \
        dep \
        ttf-hack \
        skk-jisyo
fi
