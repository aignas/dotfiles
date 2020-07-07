// +build tools

package tools

import (
	_ "github.com/gokcehan/lf"
	_ "github.com/golangci/golangci-lint/cmd/golangci-lint"
	_ "golang.org/x/tools/cmd/gorename"
	_ "golang.org/x/tools/cmd/stringer"
	_ "golang.org/x/tools/gopls"
	_ "mvdan.cc/sh/v3/cmd/shfmt"
)