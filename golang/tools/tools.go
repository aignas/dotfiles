// +build tools

package tools

import (
	_ "github.com/bazelbuild/bazelisk"
	_ "github.com/gokcehan/lf"
	_ "golang.org/x/tools/cmd/godoc"
	_ "golang.org/x/tools/cmd/goimports"
	_ "golang.org/x/tools/cmd/gorename"
	_ "golang.org/x/tools/cmd/stringer"
	_ "golang.org/x/tools/gopls"
	_ "mvdan.cc/sh/v3/cmd/shfmt"
)
