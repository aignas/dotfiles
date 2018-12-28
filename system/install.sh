#!/bin/bash

set -e

readonly common=(httpie fd exa ripgrep bat htop neovim ranger zsh hub nnn)
cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source script/logging.sh

echo "The detected OS is ${DOTFILES_OS}"
if [[ ${DOTFILES_OS} == "Mac" ]]; then
  info "brew update"
  brew update

  info "Installing packages"
  bottles=("${common[@]}" python3)
  casks=(alacritty font-hack signal)
  brew install "${bottles[@]}"
  brew upgrade "${bottles[@]}"
  brew tap homebrew/cask-fonts
  brew cask install "${casks[@]}"
  brew cask upgrade "${casks[@]}"
elif [[ ${DOTFILES_OS} == "ArchLinux" ]]; then
  info "pacman update"
  sudo pacman -Syu --noconfirm

  info "Installing packages"
  pkgs=(python "${common[@]}" shellcheck alacritty alacritty-terminfo dep ttf-hack skk-jisyo)
  sudo pacman -S \
    --quiet \
    --needed \
    --noconfirm \
    "${pkgs[@]}"
  success "pacman update"
fi
