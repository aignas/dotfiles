#!/bin/bash

export GO111MODULE=on
export GOBIN=$DOTFILES/tools

if [[ -f "$(command -v go)" ]]; then
    cd ${DOTFILES}/golang/tools

    grep "_" "tools.go" |
        awk '{print $2}' |
        xargs -L 1 go install
fi
