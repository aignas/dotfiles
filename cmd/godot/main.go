package main

import (
	"os"
)

func main() {
	if err := run(os.Stdout, os.Args); err != nil {
		os.Exit(1)
	}
}
