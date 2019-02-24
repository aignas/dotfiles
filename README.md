# Dotfiles

[![Build
Status](https://travis-ci.org/aignas/dotfiles.svg?branch=master)](https://travis-ci.org/aignas/dotfiles)

Highlights:
- `XDG_DIR` support.
- `make lint` to lint files in the repo.
- `make init` to create pre-commit lint hook.
- travis CI setup.
- `dotr` script, which is used to update system and sync with the github repo.
  Run this every time every day at the start of your working routine.

## Install

```sh
git clone https://github.com/aignas/dotfiles ~/src/github/aignas/dotfiles
ln -s ~/src/github/aignas/dotfiles ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`,
which sets up a few paths that'll be different on your particular machine.

`dotr` is a simple script that installs some dependencies, sets sane OS X
defaults, and so on. Tweak this script, and occasionally run `dotr` from time to
time to keep your environment fresh and up-to-date. You can find this script in
`bin/`.

## Thanks

This is initially based on wonderful [dotfiles
framework](https://github.com/holman/dotfiles) by Zach Holman.  However, in
time this has been simplified and adjusted to suit my needs better.  Initial
thanks note by Zach:

> I forked [Ryan Bates](http://github.com/ryanb)' excellent
> [dotfiles](http://github.com/ryanb/dotfiles) for a couple years before the
> weight of my changes and tweaks inspired me to finally roll my own. But Ryan's
> dotfiles were an easy way to get into bash customization, and then to jump
> ship to zsh a bit later. A decent amount of the code in these dotfiles stem
> or are inspired from Ryan's original project.
