#!/bin/bash

if [[ -f "$(command -v rustup)" ]]
then
  rustup update
  rustup component add clippy rustfmt rls
fi
