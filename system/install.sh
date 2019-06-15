#!/bin/bash
set -e

readonly common=(fd exa ripgrep bat htop neovim ranger zsh nnn tig tmux)
cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source script/logging.sh

echo "The detected OS is ${DOTFILES_OS}"
if [[ ${DOTFILES_OS} == "Mac" ]]; then
  info "brew"
  brew update
  ok "brew update"
  brew cleanup
  ok "brew cleanup"
  brew upgrade
  ok "brew upgrade"
  brew cask upgrade
  ok "brew cask upgrade"

  info "Installing packages"
  bottles=("${common[@]}" python3 coreutils gnu-sed skktools fswatch sk)
  brew install "${bottles[@]}" || :

  info "Installing packages via pip"
  pip3 install --upgrade -U vim-vint
elif [[ ${DOTFILES_OS} == "ArchLinux" ]]; then
  info "pacman"
  debug "pacman: update"
  sudo pacman -Syu --noconfirm
  ok "pacman: update"

  debug "pacman: install"
  pkgs=(python base-devel "${common[@]}" shellcheck skk-jisyo pamixer otf-fira-code rustup go vint skim)
  sudo pacman -S \
    --quiet \
    --needed \
    --noconfirm \
    "${pkgs[@]}"
  ok "pacman: install"
fi
