#!/bin/bash

git -C "${DOTFILES}" config core.hooksPath .githooks || :
