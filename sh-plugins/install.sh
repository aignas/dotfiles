#!/bin/bash

readonly local plugins=git_prompt
readonly local bin_dir="${DOTFILES}/sh-plugins/bin"

mkdir -p "${bin_dir}"

for i in ${plugins}
do
  echo "=== Building $i ==="
  pushd "${DOTFILES}/sh-plugins/$i" || exit 1
  cargo -Z unstable-options build --release --out-dir "${bin_dir}"
  popd || exit 1
done
