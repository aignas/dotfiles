#!/bin/bash
set -euo pipefail

readonly sha256=824c8a36c75f59c1642ff229719b121aadd901e7e1165ec5faa70db74c9e6926
readonly version=0.7.1-1
readonly flavour=testing
readonly target="${HOME}/Downloads/alacritty-latest.deb"

rm -f "$target"
curl \
    --create-dirs \
    --output "$target" \
    --location \
    "https://github.com/barnumbirr/alacritty-debian/releases/download/v$version/alacritty_${version}_amd64_debian_${flavour}.deb"

echo "Checking sha256"
echo "${sha256} ${target}" | sha256sum --check || (
    echo "sha256 mismatch"
    echo "Expected: $sha256"
    echo "Got:      $(sha256sum "$target" | awk '{print $1}')"
    exit 1
)
sudo dpkg -i "$target"
