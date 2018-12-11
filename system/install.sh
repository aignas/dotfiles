#!/bin/bash

readonly common=(httpie fd exa ripgrep bat htop neovim ranger zsh hub)

echo "The detected OS is ${DOTFILES_OS}"
if [[ ${DOTFILES_OS} == "Mac" ]]; then
  echo "› brew update"
  brew update
  echo "› Installing packages"
  bottles=("${common[@]}" python3)
  casks=(alacritty font-hack signal)
  brew install "${bottles[@]}"
  brew upgrade "${bottles[@]}"
  brew tap homebrew/cask-fonts
  brew cask install "${casks[@]}"
  brew cask upgrade "${casks[@]}"
elif [[ ${DOTFILES_OS} == "ArchLinux" ]]; then
  echo "› pacman update"
  sudo pacman -Syu
  echo "› Installing packages"
  pkgs=(python "${common[@]}" shellcheck alacritty dep ttf-hack skk-jisyo)
  sudo pacman -S --needed "${pkgs[@]}"
fi
