#!/bin/bash

export GO111MODULE=on
go get golang.org/x/tools/gopls@latest
go get golang.org/x/tools/cmd/stringer@latest
go get golang.org/x/tools/cmd/gorename@latest
go get github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go get github.com/sourcegraph/src-cli/cmd/src@latest
