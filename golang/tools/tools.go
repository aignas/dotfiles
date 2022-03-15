// +build tools

package tools

import (
	_ "github.com/bazelbuild/bazelisk"
	_ "github.com/git-hooks/git-hooks"
	_ "github.com/gokcehan/lf"
	_ "github.com/golangci/golangci-lint/cmd/golangci-lint"
	_ "github.com/haya14busa/go-vimlparser/cmd/vimlparser"
	_ "github.com/lighttiger2505/sqls"
	_ "golang.org/x/tools/cmd/godoc"
	_ "golang.org/x/tools/cmd/goimports"
	_ "golang.org/x/tools/cmd/gorename"
	_ "golang.org/x/tools/cmd/stringer"
	_ "golang.org/x/tools/gopls"
	_ "mvdan.cc/sh/v3/cmd/shfmt"
)
