#!/bin/bash

echo "Getting up Zplug"
if [ ! -d ${HOME}/.zplug ]
then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh

fi
