#!/bin/bash
set -euo pipefail

readonly sha256=815259faa2fc543b7a8bf2aeff00dbc1f181c2581663a31c1f732cfc589cf57e
readonly version=0.7.2-2
readonly flavour=testing
readonly target="${HOME}/Downloads/alacritty-${version}_amd64.deb"

curl \
    --create-dirs \
    --output "$target.new" \
    --location \
    "https://github.com/barnumbirr/alacritty-debian/releases/download/v$version/alacritty_${version}_amd64_debian_${flavour}.deb"

echo "Checking sha256"
echo "${sha256} ${target}.new" | sha256sum --check || (
    echo "sha256 mismatch"
    echo "Expected: $sha256"
    echo "Got:      $(sha256sum "$target.new" | awk '{print $1}')"
    exit 1
)
mv "$target.new" "$target"
sudo dpkg -i "$target"
