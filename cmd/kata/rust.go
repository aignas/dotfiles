package main

import (
	"fmt"
)

func bootstrap_rust(name string) error {
	err := cargo(
		"init",
		"--vcs", "none",
		"--edition", "2018",
		"--name", name,
		"--lib",
	)
	if err != nil {
		return fmt.Errorf("setup: %v", err)
	}

	return cargo("test")
}

func cargo(args ...string) error {
	return sh("cargo", args...)
}
