# Dotfiles

Travis: [![Build Status](https://travis-ci.org/aignas/dotfiles.svg?branch=master)](https://travis-ci.org/aignas/dotfiles)

[aignas/shed](https://hub.docker.com/r/aignas/shed/):
[![aignas/shed container status](https://images.microbadger.com/badges/image/aignas/shed.svg)](https://microbadger.com/images/aignas/shed "Docker image badger from microbadger.com")

Highlights:
- `XDG_DIR` support.
- `dot --lint` to lint files in the repo.
- logging for timing the installations.
- dependency framework to run the install.sh files are run in a particular order.
- some consistency checks of the configuration.
- travis CI setup.
- `dot` script, which is used to update system and sync with the github repo.
  Run this every time every day at the start of your working routine.
- Async information about the current git repository in the ZSH prompt without
  any plugins.

## Install

```sh
$ git clone https://github.com/aignas/dotfiles ~/src/github/aignas/dotfiles
$ ln -s ~/src/github/aignas/dotfiles ~/.dotfiles
$ cd ~/.dotfiles
$ dotr
```

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`,
which sets up a few paths that'll be different on your particular machine.

`dotr` is a simple script that installs some dependencies, sets sane OS X
defaults, and so on. Tweak this script, and occasionally run `dotr` from time to
time to keep your environment fresh and up-to-date. You can find this script in
`bin/`.

## Toolshed

[aignas/shed](https://hub.docker.com/r/aignas/shed/) is a docker
image with many command-line tools.

### Usage

Setup:
```sh
$ grep -A3 shed ~/.zshrc
shed() {
    docker run --name shed -v `pwd`:/x -w /x -ti --rm aignas/shed "$@"
}
```

The above will execute the shed with `/x/` mounted as the current directory.

### A few examples

A Bash prompt in a rich environment:
```sh
$ shed
```

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
