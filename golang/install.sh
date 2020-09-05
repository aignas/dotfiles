#!/bin/bash

export GO111MODULE=on
export GOBIN=$DOTFILES/tools

if [[ -f "$(command -v go)" ]]; then
    grep "_" "${DOTFILES}/golang/tools.go" |
        awk '{print $2}' |
        xargs -L 1 go install
fi
