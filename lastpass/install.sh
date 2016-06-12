#!/bin/sh

DOTFILES_OS=`uname -s`

# Handle OS X install
if [[ ${DOTFILES_OS} == "Darwin" ]]; then
    brew install lastpass-cli --with-pinentry
fi
