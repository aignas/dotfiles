#!/bin/bash

set -e

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
source script/logging.sh

readonly local plugins=git_prompt
readonly local bin_dir="${DOTFILES}/sh-plugins/bin"

mkdir -p "${bin_dir}"

info "Building shell plugins..."
for i in ${plugins}
do
  info "Building $i..."
  pushd "${DOTFILES}/sh-plugins/$i" || fail "plug-in not found"
  cargo -Z unstable-options build --release --out-dir "${bin_dir}"
  popd || fail "failed to popd"
done

success "Done building shell plugins"
