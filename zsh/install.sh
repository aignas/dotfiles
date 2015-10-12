#!/bin/bash

echo "Setting up Zgen"
mkdir -p "${HOME}/src/github/zgen"
git clone https://github.com/tarjoilija/zgen.git "${HOME}/src/github/zgen"

# Install the pencil-light theme into the terminal
bash ${HOME}/.dotfiles/zsh/pencil-light.sh
