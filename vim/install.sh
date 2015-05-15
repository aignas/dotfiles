#!/bin/bash

mkdir -p ~/.vim/bundle
TARGET_DIR=~/.vim/bundle/Vundle.vim

if [ -d ${TARGET_DIR} ]; then
    cd ${TARGET_DIR}
    git pull
    cd -
else
    git clone https://github.com/gmarik/Vundle.vim.git ${TARGET_DIR}
fi
