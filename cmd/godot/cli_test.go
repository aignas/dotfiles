package main

import (
	"bytes"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestRun(t *testing.T) {
	var stdout bytes.Buffer
	err := run(&stdout, []string{"binary", "unnecessary", "arg"})
	assert.Regexp(t, "^Unknown command `unnecessary'.", err)
	assert.Regexp(t, "^Unknown command `unnecessary'.", stdout.String())
}
