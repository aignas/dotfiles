#!/bin/bash

if [[ -f "$(command -v rustup)" ]]
then
  rustup update stable
fi
