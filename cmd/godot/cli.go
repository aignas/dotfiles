package main

import (
	"fmt"
	"io"

	"go.uber.org/zap"
)

type globalArgs struct {
	LoggingOptions struct {
		Verbose []bool `short:"v" long:"verbose" description:"make logging more verbose"`
	} `group:"Logging options"`
}

type commandFactory func(*globalArgs, *zap.Logger) command

var _commands = []commandFactory{
	NewInstallCommand,
	NewLinkCommand,
}

// run is the main entry point for which should be accessed from the main
// function. The stdout is os.Stdout. The args parameter is usually os.Args.
func run(stdout io.Writer, args []string) error {
	if err := runCLI(args); err != nil {
		fmt.Fprintln(stdout, err)
		return err
	}
	return nil
}

func runCLI(args []string) error {
	logger, err := zap.NewDevelopment()
	if err != nil {
		return err
	}

	var globals globalArgs
	parser := newParser(&globals)
	for _, f := range _commands {
		if err := parser.AddCommand(f(&globals, logger)); err != nil {
			return fmt.Errorf("add command: %w", err)
		}
	}

	if err := parser.ParseArgs(args); err != nil {
		return err
	}
	return nil
}
