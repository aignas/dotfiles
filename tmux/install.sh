#!/usr/bin/env bash

DIR=$HOME/.tmux/plugins/tpm
[[ -d "$DIR" ]] || \
  git clone \
    --depth=1 \
    --branch=master \
    https://github.com/tmux-plugins/tpm "$DIR"
