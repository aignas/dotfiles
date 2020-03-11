#!/bin/bash

export GO111MODULE=on
export GOBIN=$DOTFILES/tools

grep "_" "${DOTFILES}/golang/tools.go" |
    awk '{print $2}' |
    xargs -L 1 go install
