#!/bin/bash

# For differences between the language servers one can visit: https://fferences between go-langserver, bingo, golsp
# Copy below:
#
# - [go-langserver](https://github.com/sourcegraph/go-langserver)
#
# > go-langserver is designed for online code reading such as github.com.
#
# - [bingo](https://github.com/saibing/bingo)
#
# > bingo is designed for offline editors such as vscode, vim, it focuses on code editing.
#
# - [gopls](https://github.com/golang/tools/blob/master/cmd/gopls/main.go)
#
# > gopls is an official language server,  and it is currently in early development.
#

set -oe pipefail

DIR="${HOME}/src/github/saibing/bingo.git/"
if [[ -d "$DIR" ]]; then
  git -C "$DIR" fetch origin
  git -C "$DIR" reset --hard origin/master
else
  git clone https://github.com/saibing/bingo.git "$DIR"
fi
cd "$DIR" && GO111MODULE=on go install
