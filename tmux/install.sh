#!/bin/bash

TARGET_DIR="${HOME}/src/github"

# Ensure that the target directory exists
mkdir -p ${TARGET_DIR}

if [ -d ${TARGET_DIR}/powerline ]; then
    echo "Updating powerline"
    cd ${TARGET_DIR}/powerline
    git pull --rebase
else
    echo "Downloading powerline"
    git clone git@github.com:powerline/powerline.git ${TARGET_DIR}/powerline
fi
