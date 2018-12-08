#!/bin/bash

readonly common=(httpie fd exa ripgrep bat htop neovim ranger zsh)

echo "The detected OS is ${DOTFILES_OS}"
if [[ ${DOTFILES_OS} == "Mac" ]]; then
  bottles=("${common[@]}" python3)
  casks=(alacritty font-hack)
  brew install "${bottles[@]}"
  brew upgrade "${bottles[@]}"
  brew tap homebrew/cask-fonts
  brew cask install "${casks[@]}"
  brew cask upgrade "${casks[@]}"
elif [[ ${DOTFILES_OS} == "ArchLinux" ]]; then
  pkgs=(python "${common[@]}" shellcheck alacritty dep ttf-hack skk-jisyo)
  sudo pacman -Sy --needed "${pkgs[@]}"
fi
