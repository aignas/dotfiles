#!/bin/sh

cd "$(dirname "$0")"
exec ./fzf/install --xdg --no-update-rc --completion --key-bindings
