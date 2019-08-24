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
# > bingo is designed for offline editors such as vscode, vim, it focuses on
# code editing.
#
# - [gopls](https://github.com/golang/go/wiki/gopls)
#
# > gopls is an official language server,  and it is currently in early development.
#

export GO111MODULE=on
go get golang.org/x/tools/gopls@latest
go get github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go get mvdan.cc/sh/cmd/shfmt@latest
