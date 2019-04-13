#!/bin/bash -e

readonly common=(httpie fd exa ripgrep bat htop neovim ranger zsh hub nnn tig entr)
cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source script/logging.sh

echo "The detected OS is ${DOTFILES_OS}"
if [[ ${DOTFILES_OS} == "Mac" ]]; then
  info "brew update"
  brew update
  info "brew cleanup"
  brew cleanup
  info "brew upgrade"
  brew upgrade

  info "Installing packages"
  bottles=("${common[@]}" python3 gnu-sed skktools)
  casks=(alacritty font-hack signal font-fira-code)
  brew install "${bottles[@]}"
  brew upgrade "${bottles[@]}"
  brew tap homebrew/cask-fonts
  brew cask install "${casks[@]}"
  brew cask upgrade "${casks[@]}"

  info "Installing packages via pip"
  pip3 install --upgrade -U vim-vint
elif [[ ${DOTFILES_OS} == "ArchLinux" ]]; then
  info "pacman"
  info "pacman: cleanup"
  sudo pacman -Sc
  success "pacman: cleanup"

  info "pacman: update"
  sudo pacman -Syu --noconfirm
  sucess "pacman: update"

  info "pacman: install"
  pkgs=(python "${common[@]}" shellcheck alacritty alacritty-terminfo dep ttf-hack skk-jisyo pamixer otf-fira-code rustup go vint)
  sudo pacman -S \
    --quiet \
    --needed \
    --noconfirm \
    "${pkgs[@]}"
  sucess "pacman: install"
fi
