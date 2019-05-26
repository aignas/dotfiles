#!/bin/bash

[[ ${DOTFILES_OS} != "Mac" ]] && exit 0

readonly filename=MacOS-lt-std-keyboard-layout.zip
readonly dest="${HOME}/Library/Keyboard Layouts"

curl http://www.ims.mii.lt/klav/MacOS-X.zip > ${filename}
trap 'rm ${filename}' EXIT

# Unpack into target
unzip -o ${filename} -d "${dest}"
trap - EXIT
rm ${filename}
