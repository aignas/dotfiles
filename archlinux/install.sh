#!/bin/bash

if [ ! -f "/etc/arch-release" ]; then
    # echo "This is not ArchLinux"
    exit 0;
fi

echo "This is ArchLinux"

echo "Installing various packages"
sudo pacman -S \
    base \
    base-devel \
    openssh \
    git \
    gnome \
    qutebrowser \
    neovim \
    tmux \
    ruby \
    python \
    python2 \
    ranger \
    xclip

aurb \
    aura-bin \
    hugo \
    google-chrome
