#!/bin/bash
set -euo pipefail

readonly sha256=9508317393f32b467057b8024d9712434ee5691094b3e638c551588559a5da3c
readonly version=0.7.2-1
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
