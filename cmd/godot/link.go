package main

import (
	"errors"
	"os"
	"path/filepath"
	"strings"

	"go.uber.org/zap"
)

type linkCommand struct {
	Root   string `long:"dir" env:"DOTFILES_ROOT" description:"root directory"`
	Home   string `long:"home" description:"The home folder" env:"HOME" hidden:"true"`
	Config string `long:"xdg-config" description:"XDG_CONFIG_HOME" env:"XDG_CONFIG_HOME"`

	Overwrite bool `short:"o" long:"overwrite" description:"Replace existing dotfiles with dotfile symlinks"`
	Backup    bool `short:"b" long:"backup" description:"Backup the existing dotfiles before creating dotfile symlinks"`

	Args struct {
		File string `positional-arg-name:"FILE" required:"true"`
	} `positional-args:"true"`

	logger *zap.Logger
}

func NewLinkCommand(globals *globalArgs, logger *zap.Logger) command {
	return command{
		Name:  "link",
		Short: "Create dotfile symlinks.",
		Long:  "Create symlinks in the HOME directory to the config files in this repo.",

		Commander: newLinkCommand(logger),
	}
}

func newLinkCommand(logger *zap.Logger) *linkCommand {
	return &linkCommand{
		logger: logger,
	}
}

func (c *linkCommand) Execute([]string) error {
	src := c.Args.File
	dst, err := c.Destination(src)
	if err != nil {
		return err
	}

	status, err := c.Prep(dst)
	if err != nil {
		return err
	}

	if status != "skip" {
		abs, err := filepath.Abs(src)
		if err != nil {
			return err
		}

		if err := os.Symlink(abs, dst); err != nil {
			return nil
		}
	}

	c.logger.Info(status, zap.String("dest", dst))
	return nil
}

func (c *linkCommand) Prep(dst string) (string, error) {
	_, err := os.Lstat(dst)
	if err != nil && os.IsNotExist(err) {
		return "create", nil
	}

	if err != nil {
		return "", nil
	}

	// TODO: bad symlink

	if c.Backup {
		if err := os.Rename(dst, dst+".bak"); err != nil {
			return "", err
		}
		return "backup", nil
	}

	if c.Overwrite {
		if err := os.RemoveAll(dst); err != nil {
			return "", err
		}
		return "overwrite", nil
	}

	return "skip", nil
}

func (c *linkCommand) Destination(src string) (string, error) {
	ext := filepath.Ext(src)
	base := strings.TrimSuffix(filepath.Base(src), ext)

	if ext == ".symlink" {
		return filepath.Join(c.Home, "."+base), nil
	}

	if ext != ".xdg" {
		return "", errors.New("unknown file")
	}

	if c.Config == "" {
		c.Config = filepath.Join(c.Home, ".config")
	}
	dst := filepath.Join(c.Config, base)
	if err := os.MkdirAll(dst, 0755); err != nil {
		return "", err
	}
	return dst, nil
}
