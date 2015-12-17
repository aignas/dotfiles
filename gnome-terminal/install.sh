#!/bin/bash

REPO="https://github.com/anuragsoni/seoul256-gnome-terminal"
DEST="/tmp/gnome-terminal-theme"

rm -rf ${DEST}
git clone ${REPO} ${DEST}
pushd ${DEST}
source ${DEST}/seoul256-dark.sh
popd
