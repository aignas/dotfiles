#!/bin/bash

readonly _gh=${DOTFILES}/tools/git-hooks

echo "UPDATING git-hooks"
curl -o "$_gh" https://raw.githubusercontent.com/icefox/git-hooks/master/git-hooks
chmod +x "$_gh"
"$_gh" --install || :
