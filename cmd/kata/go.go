package main

import (
	"io/ioutil"
	"os"
)

const (
	_mainTemplate = `package main

import "fmt"

func result() string {
	return "foo"
}

func main() {
	fmt.Printf("Result is: %s", result())
}
`

	_testTemplate = `package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestResult(t *testing.T) {
	t.Skip()
	assert.False(t, true)
}
`
)

func bootstrap_go(name string) error {
	if err := os.Setenv("GO111MODULE", "on"); err != nil {
		return err
	}

	gotool("mod", "init", "github.com/aignas/katas/"+name)

	if err := writeGoFile("main.go", _mainTemplate); err != nil {
		return err
	}

	if err := writeGoFile("main_test.go", _testTemplate); err != nil {
		return err
	}

	return gotool("test", "./...")
}

func writeGoFile(name, text string) error {
	if err := ioutil.WriteFile(name, []byte(text), 0755); err != nil {
		return err
	}

	return gotool("fmt", name)
}

func gotool(args ...string) error {
	return sh("go", args...)
}
