#!/bin/bash

export GO111MODULE=on
export GOBIN=$DOTFILES/tools
readonly _go_version=1.18.0
mkdir -p ${GOBIN}

if [[ -f "$(command -v goenv)" ]]; then
    echo Installing go applications
    goenv install --skip-existing "${_go_version}"
    goenv local "${_go_version}"
    goenv rehash
fi


if [[ -f "$(command -v go)" ]]; then
    pushd ${DOTFILES}/golang/tools
    grep "_" "tools.go" |
        awk '{print $2}' |
        xargs -L 1 go install
    popd
fi

if [[ -f "$(command -v bazelisk)" ]]; then
    echo Aliasing bazelisk to bazel
    pushd ${GOBIN}
    rm -f bazel
    ln -s bazelisk bazel
    popd
fi
