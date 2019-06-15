#!/bin/bash
set -e

echo "The detected OS is ${DOTFILES_OS}"
[[ ${DOTFILES_OS} != "ArchLinux" ]] && return 0
if [ "$EUID" -eq 0 ]; then
    echo "Install AUR dependencies as user"
    exit 0
fi

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source script/logging.sh

for p in fswatch-git git-prompt-rs-git; do
    info "Installing from AUR: $p"
    d=${HOME}/aur/$p
    if [[ -d "$d" ]]; then
        git -C "$d" stash || :
        git -C "$d" pull --rebase origin master
        git -C "$d" stash pop || :
    else
        git clone https://aur.archlinux.org/$p.git "$d"
    fi
    pushd "$d"
    makepkg -si --noconfirm
    popd
done
ok "AUR"
