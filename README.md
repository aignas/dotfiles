# Dotfiles

Highlights:
- `XDG_DIR` support.
- Single command bootstrap with `nix run`.
- [home-manager] configuration as a nix flake, with `nixpkgs` and
  `home-manager` pinned in `flake.lock`.
- `dotr` script, which is used to update system and sync with the github repo.
  Run this every time every day at the start of your working routine.
- logging for timing the installations.

[home-manager]: https://github.com/nix-community/home-manager

## Install

The only prerequisite is [nix](https://nixos.org/download/). Then run:

```sh
nix --extra-experimental-features 'nix-command flakes' run github:aignas/dotfiles
```

This will:
1. Clone this repo to `~/src/github/aignas/dotfiles` and symlink it to
   `~/.dotfiles`, unless `~/.dotfiles` already exists.
2. Ask for the git author email and write `~/.gitconfig.local`.
3. Install the system packages with `pacman` or `apt-get` (needs `sudo`).
4. Apply the `home-manager` configuration from the flake, which installs the
   rest of the packages and links the configuration files into the home
   directory.

The `home-manager` configuration is selected by the username, see
`homeConfigurations` in [flake.nix](flake.nix). If `home-manager` refuses to
overwrite files that already exist in the home directory, move them out of the
way or run `~/.dotfiles/bin/renix -b bak` to back them up.

## Usage

Everything is configured and tweaked within `~/.dotfiles`. Once bootstrapped,
the following scripts from `bin/` are on the `PATH`:

- `dotr` pulls the latest changes, upgrades the system packages and applies
  the configuration. Run it from time to time to keep your environment fresh
  and up-to-date.
- `renix` only applies the `home-manager` configuration, use it after changing
  something in the repo. The flags are passed to `home-manager switch`.
- `renix --update` additionally bumps `nixpkgs` and `home-manager` in
  `flake.lock`. Commit the result to keep all machines on the same versions.

## Thanks

This was initially based on wonderful [dotfiles
framework](https://github.com/holman/dotfiles) by Zach Holman.  However, in
time this has been simplified and adjusted to suit my needs better.  Initial
thanks note by Zach:

> I forked [Ryan Bates](http://github.com/ryanb)' excellent
> [dotfiles](http://github.com/ryanb/dotfiles) for a couple years before the
> weight of my changes and tweaks inspired me to finally roll my own. But Ryan's
> dotfiles were an easy way to get into bash customization, and then to jump
> ship to zsh a bit later. A decent amount of the code in these dotfiles stem
> or are inspired from Ryan's original project.
