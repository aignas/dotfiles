#!/bin/bash

DIR=$HOME/.tmux/plugins/tpm

if [ ! -d $DIR ]; then
    git clone https://github.com/tmux-plugins/tpm $DIR
fi
