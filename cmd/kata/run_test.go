package main

import (
	"bytes"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestIsHelp(t *testing.T) {
	t.Run("nil err", func(t *testing.T) {
		assert.False(t, isHelp(nil))
	})

	t.Run("random err", func(t *testing.T) {
		assert.False(t, isHelp(assert.AnError))
	})
}

func TestRun(t *testing.T) {
	args := func(args ...string) []string {
		return args
	}

	t.Run("help returns 0", func(t *testing.T) {
		assert.Zero(t, run(args("--help"), &global{
			stdout: &bytes.Buffer{},
		}))
	})

	t.Run("print to stdout", func(t *testing.T) {
		var out bytes.Buffer

		assert.Zero(t, run(args("--help"), &global{
			stdout: &out,
		}))
		assert.Contains(t, out.String(), "--help")
	})

	t.Run("print err to stderr", func(t *testing.T) {
		var out bytes.Buffer

		assert.Equal(t, 1, run(args("--bad-arg"), &global{
			stderr: &out,
		}))
		assert.Contains(t, out.String(), "unknown flag")
	})

	t.Run("log message, dry run", func(t *testing.T) {
		var out bytes.Buffer

		assert.Zero(t, run(args("--dry-run", "rust", "tar"), &global{
			stderr: &out,
		}))
		assert.Contains(t, out.String(), "Bootstrapping a Kata env")
	})

	t.Run("too many args", func(t *testing.T) {
		var out bytes.Buffer

		assert.Equal(t, 1, run(args("rust", "too", "many", "args"), &global{
			stderr: &out,
		}))
		assert.Contains(t, out.String(), "unknown positional args:")
	})

	t.Run("unknown language", func(t *testing.T) {
		var out bytes.Buffer

		assert.Equal(t, 1, run(args("rusty", "tar"), &global{
			stderr: &out,
		}))
		assert.Contains(t, out.String(), "unknown language: rusty")
	})
}

func Test_global_Log(t *testing.T) {
	t.Run("logs to stderr", func(t *testing.T) {
		var stdout, stderr bytes.Buffer
		p := global{
			stdout: &stdout,
			stderr: &stderr,
		}
		p.Log("foo")
		assert.Empty(t, stdout.String())
		assert.Equal(t, "foo", stderr.String())
	})

	t.Run("interpolates templates", func(t *testing.T) {
		var stderr bytes.Buffer
		p := global{stderr: &stderr}
		p.Log("foo: %q", "something")
		assert.Equal(t, "foo: \"something\"", stderr.String())
	})
}
