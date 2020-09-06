package main

import (
	"io/ioutil"
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func withTmp(t *testing.T, pattern string) string {
	dir, err := ioutil.TempDir("", pattern)
	require.NoError(t, err)
	t.Cleanup(func() { os.RemoveAll(dir) })
	return dir
}

func Test_newApp(t *testing.T) {
	t.Run("validate err", func(t *testing.T) {
		a, err := newApp("", "", nil)
		assert.Zero(t, a)
		assert.EqualError(t, err, "root dir must be specified")
	})

	t.Run("ok", func(t *testing.T) {
		a, err := newApp("shell", withTmp(t, "new"), nil)
		assert.NotZero(t, a)
		assert.NoError(t, err)
	})
}

func Test_app_validate(t *testing.T) {
	// fixtures
	testdata := withTmp(t, "validate")

	testdataNonEmpty := withTmp(t, "non-empty")
	mod := filepath.Join(testdataNonEmpty, "foo")
	require.NoError(t, os.Mkdir(mod, 0755))
	_, err := os.Create(filepath.Join(mod, "install.sh"))
	require.NoError(t, err)

	testdataManyLevels := withTmp(t, "many-levels")
	mod = filepath.Join(testdataManyLevels, "foo")
	require.NoError(t, os.Mkdir(mod, 0755))
	mod = filepath.Join(mod, "bar")
	require.NoError(t, os.Mkdir(mod, 0755))
	_, err = os.Create(filepath.Join(mod, "install.sh"))
	require.NoError(t, err)

	testdataOtherFile := withTmp(t, "other-file")
	mod = filepath.Join(testdataOtherFile, "foo")
	require.NoError(t, os.Mkdir(mod, 0755))
	_, err = os.Create(filepath.Join(mod, "some-file.sh"))
	require.NoError(t, err)

	tests := []struct {
		msg     string
		wizard  wizard
		wantErr string
	}{
		{
			msg: "ok",
			wizard: wizard{
				root:  testdata,
				shell: "bar",
			},
			wantErr: "",
		},
		{
			msg: "root dir err",
			wizard: wizard{
				shell: "bar",
			},
			wantErr: "root dir must be specified",
		},
		{
			msg: "shell err",
			wizard: wizard{
				root: testdata,
			},
			wantErr: "shell must be specified",
		},
		{
			msg: "duplicates",
			wizard: wizard{
				root:     testdata,
				shell:    "bar",
				installs: []string{"baz", "baz"},
			},
			wantErr: "install list contains duplicates",
		},
		{
			msg: "non-existent",
			wizard: wizard{
				root:  "non-existent",
				shell: "bar",
			},
			wantErr: "lstat non-existent: no such file or directory",
		},
		{
			msg: "unknown module",
			wizard: wizard{
				root:  testdataNonEmpty,
				shell: "bar",
			},
			wantErr: "unknown module: \"foo\"",
		},
		{
			msg: "ok",
			wizard: wizard{
				root:     testdataNonEmpty,
				shell:    "bar",
				installs: []string{"foo"},
			},
		},
		{
			msg: "ok only one level",
			wizard: wizard{
				root:  testdataManyLevels,
				shell: "bar",
			},
		},
		{
			msg: "ok, no install.sh file",
			wizard: wizard{
				root:  testdataOtherFile,
				shell: "bar",
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.msg, func(t *testing.T) {
			err := tt.wizard.validate()

			if tt.wantErr != "" {
				assert.EqualError(t, err, tt.wantErr)
				return
			}
			assert.NoError(t, err)
		})
	}
}
