package main

import (
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"

	"go.uber.org/zap"
)

type installCommand struct {
	Shell string `long:"shell" env:"SHELL" description:"shell to use" hidden:"true"`
	Root  string `long:"dir" env:"DOTFILES_ROOT" description:"root directory"`

	Args struct {
		Modules []string `positional-arg-name:"MODULE" choice:"golang" choice:"neovim" choice:"rust" choice:"system" description:"Modules to install. If empty installs all."`
	} `positional-args:"true"`

	logger *zap.Logger
}

// NewInstallCommand constructs a new install command.
func NewInstallCommand(globals *globalArgs, logger *zap.Logger) command {
	return command{
		Name:  "install",
		Short: "Install system modules.",
		Long:  "Install system modules.",

		Commander: newInstallCommand(logger),
	}
}

func newInstallCommand(logger *zap.Logger) *installCommand {
	return &installCommand{
		logger: logger,
	}
}

func (c *installCommand) Execute([]string) error {
	wizard, err := newApp(
		c.Shell,
		c.Root,
		[]string{"golang", "neovim", "rust", "system"},
	)
	if err != nil {
		return err
	}

	installs := c.Args.Modules
	if len(installs) == 0 {
		installs = wizard.installs
	}

	for _, dir := range installs {
		c.logger.Info("Setting up module", zap.String("dir", dir))

		if err := wizard.install(dir); err != nil {
			c.logger.Error("Failed", zap.Error(err))
			return err
		}
		c.logger.Info("Success")
	}

	return nil
}

type wizard struct {
	shell    string
	root     string
	installs []string
}

func newApp(shell, root string, installs []string) (*wizard, error) {
	wizard := wizard{
		shell:    shell,
		root:     root,
		installs: installs,
	}

	if err := wizard.validate(); err != nil {
		return nil, err
	}
	return &wizard, nil
}

func (a *wizard) install(component string) error {
	cmd := exec.Command(
		a.shell, "-ceuo", "pipefail",
		filepath.Join(a.root, component, "install.sh"))
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	return cmd.Run()
}

func (a *wizard) validate() error {
	if a.root == "" {
		return fmt.Errorf("root dir must be specified")
	}

	if a.shell == "" {
		return fmt.Errorf("shell must be specified")
	}

	set := newSet(a.installs...)
	if d := len(a.installs) - len(set); d > 0 {
		return errors.New("install list contains duplicates")
	}

	return filepath.Walk(a.root, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			//a.logger.Error("failed to access dir", zap.String("path", path), zap.Error(err))
			return err
		}

		if info.IsDir() {
			if path == a.root || filepath.Dir(path) == a.root {
				return nil
			}

			// descend only a single level
			//fmt.Printf("skipping a dir without errors: %+v \n", info.Name())
			return filepath.SkipDir
		}

		if info.Name() != "install.sh" {
			return nil
		}

		if mod := filepath.Base(filepath.Dir(path)); !set.Contains(mod) {
			return fmt.Errorf("unknown module: %q", mod)
		}
		return nil
	})
}
