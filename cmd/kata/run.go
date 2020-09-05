package main

import (
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"

	"github.com/jessevdk/go-flags"
)

// Language is the supported language
type Language uint

const (
	RustLanguage Language = iota + 1
	GoLanguage
)

var _langStrings = map[Language]string{
	GoLanguage:   "go",
	RustLanguage: "rust",
}

func (l Language) String() string {
	if s, ok := _langStrings[l]; ok {
		return s
	}

	return "<unknown>"
}

func (l *Language) UnmarshalFlag(value string) error {
	for lang, s := range _langStrings {
		if s == value {
			*l = lang
			return nil
		}
	}

	return fmt.Errorf("unknown language: %s", value)
}

type global struct {
	KataDir string `long:"kata-dir" description:"The path to create the kata in" default:"${HOME}/src/learning/katas"`
	DryRun  bool   `long:"dry-run"`

	Args struct {
		Language Language `long:"lang" positional-arg-name:"LANG" choice:"rust" choice:"go"`
		Name     string   `positional-arg-name:"NAME"`
	} `positional-args:"true" required:"yes"`

	stdout io.Writer
	stderr io.Writer
}

// Run is the main entry point
func Run(args []string) int {
	return run(args, &global{
		stdout: os.Stdout,
		stderr: os.Stderr,
	})
}

func run(args []string, params *global) int {
	if err := parseArgs(args, params); err != nil {
		if isHelp(err) {
			fmt.Fprintln(params.stdout, err.Error())
			return 0
		}

		params.Log(err.Error())
		return 1
	}

	if err := bootstrap(params); err != nil {
		params.Log("Err occurred: %s\n", err)
		return 1
	}

	return 0
}

func parseArgs(args []string, params *global) error {
	remaining, err := flags.NewParser(params, flags.HelpFlag|flags.PassDoubleDash).ParseArgs(args)

	if err != nil {
		return err
	}

	if len(remaining) != 0 {
		return fmt.Errorf("unknown positional args: %s", strings.Join(remaining, " "))
	}

	params.KataDir = filepath.Join(
		os.ExpandEnv(params.KataDir),
		fmt.Sprintf("%s-%s-%s",
			time.Now().Format("2006-01-02"),
			params.Args.Language,
			params.Args.Name))

	return nil
}

func isHelp(err error) bool {
	if err == nil {
		return false
	}

	if flagsErr, ok := err.(*flags.Error); ok && flagsErr.Type == flags.ErrHelp {
		return true
	}
	return false
}

func bootstrap(params *global) error {
	// FIXME: this is an ugly case of polimorphism, but the alternative is much
	// more code, because the go-flags does not really fit into how this is written.
	var f func(string) error
	switch lang := params.Args.Language; lang {
	case RustLanguage:
		f = bootstrap_rust
	case GoLanguage:
		f = bootstrap_go
	default:
		return fmt.Errorf("BUG: unimplemented language: %s", lang)
	}

	params.Log("Bootstrapping a Kata env for %q lang in %s\n",
		params.Args.Language,
		params.KataDir)

	if !params.DryRun {
		if err := os.MkdirAll(params.KataDir, 0755); err != nil {
			return err
		}
		if err := os.Chdir(params.KataDir); err != nil {
			return err
		}
		if err := f(params.Args.Name); err != nil {
			return err
		}
	}
	params.Log("In order to start coding:\n$ cd %s\n", params.KataDir)

	return nil
}

func (p *global) Log(format string, args ...interface{}) {
	fmt.Fprintf(p.stderr, format, args...)
}

func sh(name string, args ...string) error {
	fmt.Printf("$ %s %s\n", name, strings.Join(args, " "))
	out, err := exec.Command(name, args...).Output()
	fmt.Println(string(out))
	return err
}
