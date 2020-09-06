package main

import (
	"fmt"

	flags "github.com/jessevdk/go-flags"
)

type parser struct {
	*flags.Parser
}

func newParser(data interface{}) *parser {
	return &parser{
		Parser: flags.NewParser(data, flags.HelpFlag|flags.PassDoubleDash|flags.PassAfterNonOption),
	}
}

type command struct {
	flags.Commander

	Name  string
	Short string
	Long  string
}

func (p *parser) AddCommand(c command) error {
	if _, err := p.Parser.AddCommand(c.Name, c.Short, c.Long, c.Commander); err != nil {
		return err
	}
	return nil
}

func (p *parser) ParseArgs(args []string) error {
	leftover, err := p.Parser.ParseArgs(args[1:])
	if err != nil {
		return err
	}

	if len(leftover) != 0 {
		return fmt.Errorf("leftover args: %q", leftover)
	}
	return nil
}
