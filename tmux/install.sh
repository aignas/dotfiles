#!/bin/sh

if [[ ${DOTFILES_OS} == "Darwin" ]]
then
    brew install reattach-to-user-namespace --wrap-pbcopy-and-pbpaste
fi
