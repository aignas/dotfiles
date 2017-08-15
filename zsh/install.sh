#!/bin/bash

echo "Getting up Zplug"
if [ ! -d ${HOME}/.zplug ]
then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh

fi

# Install the colorscheme
curl https://raw.githubusercontent.com/anuragsoni/seoul256-gnome-terminal/master/seoul256-dark.sh | zsh
