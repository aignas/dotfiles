#!/bin/bash

if [[ -f "$(command -v rustup)" ]]; then
    rustup toolchain install stable beta
    rustup component add clippy rustfmt rls
    rustup default stable
    rustup update
fi
