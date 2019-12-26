#!/bin/bash
set -e

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
    bottles=(fd exa ripgrep bat htop neovim ranger zsh tig tmux watchexec shfmt python3 coreutils gnu-sed skktools)
    brew install "${bottles[@]}" || :

    brew install git-prompt-bin

    info "Installing packages via pip"
    pip3 install --upgrade -U vim-vint
elif [[ ${DOTFILES_OS} == "ArchLinux" ]]; then
    info "pacman"
    debug "pacman: update"
    sudo pacman -Syu --noconfirm
    ok "pacman: update"

    debug "pacman: install"
    pkgs=(python base-devel fd exa ripgrep bat htop neovim ranger zsh tig tmux watchexec shfmt shellcheck skk-jisyo pamixer otf-fira-code rustup go vint)
    sudo pacman -S \
        --quiet \
        --needed \
        --noconfirm \
        "${pkgs[@]}"
    ok "pacman: install"

    aurinstall() {
        local p="$1"
        info "Installing from AUR: $p"
        d=${HOME}/aur/$p
        if [[ -d $d ]]; then
            git -C "$d" stash || :
            git -C "$d" pull --rebase origin master
            git -C "$d" stash pop || :
        else
            git clone "https://aur.archlinux.org/$p.git" "$d"
        fi
        pushd "$d"
        makepkg -si --noconfirm
        popd
    }

    aurinstall git-prompt-rs-git
    ok "AUR"
elif [[ ${DOTFILES_OS} == "Debian" ]]; then
    info "apt-get"
    sudo apt-get update
    ok "apt-get: update"

    debug "apt-get: install"
    sudo apt-get install -y \
        python3 python3-venv fd-find exa ripgrep htop neovim ranger zsh tig tmux shellcheck curl unzip

    ok "apt-get: install"
fi
