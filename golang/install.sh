#!/bin/bash

export GO111MODULE=on
export GOBIN=$DOTFILES/tools

if [[ -f "$(command -v goenv)" ]]; then
    echo Installing go applications
    goenv local 1.18.0
    pushd ${DOTFILES}/golang/tools
    grep "_" "tools.go" |
        awk '{print $2}' |
        xargs -L 1 go install
    popd

    echo Aliasing bazelisk to bazel
    pushd ${GOBIN}
    rm -f bazel
    ln -s bazelisk bazel
    popd
fi
