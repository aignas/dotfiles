#!/bin/bash

FZF_PATH="${HOME}/.fzf"
REPO_PATH=https://github.com/junegunn/fzf.git 

# Clone and install everything
git clone --depth 1 ${REPO_PATH} ${FZF_PATH}
${FZF_PATH}/install
