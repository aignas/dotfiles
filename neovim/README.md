# Notes Neovim 0.5.0

I decided to also support `neovim 0.5.0`, because that will come at some point and having a config that I can use with the nightly may be interesting.

I have tried installing via snap and appimage and appimage seams to be the
easiest. The only problem I had with `snap` was that I could not use it with
`update-alternatives`.

## Snap experience:

Because the `nightly` builds are somewhat [flakey](TODO), I decided to install `neovim` on my Debian testing via `snap`
```sh
$ sudo apt-get install snapd
$ sudo snap install core
$ sudo snap install nvim --classic --edge
```

Then I could not find a way to use `update-alternatives` with snap binaries, but I can look into that later, this is the reason why I chose to set the `EDITOR` in `.zshrc`.

However, I need a more recent nightly version in order to complete the setup and the current nightly building is broken.

## Update nvim

```sh
$ sudo snap refresh nvim --classic --edge
v0.5.0-1025-g0fad952a2-nightly
```

## TODO

- [X] Need to use [packer.nvim](https://github.com/wbthomason/packer.nvim)
- [X] Can use packer with `minpac` plugin manager name to not recompile plugins
      when switching between branches.
- [X] Need to use incompatible plugins as optional plugins and then use
      `packadd` to add the plugins during runtime for different VIM versions.
- [X] Snap does not support to be used in `update-alternatives`, quite possibly
      because of how `snap` works. Hence, this branch cannot be used in
      production yet.
- [ ] Use `lua` formatters to auto format `init.lua` and friends. They can be
      installed with `luarocks` but I probably need to have `.dotfiles/lua`
      folder to manage those.
- [X] Cleanup the alternatives used in the development.

# References

- [Blog post that inspired me](https://alpha2phi.medium.com/neovim-lsp-dap-and-fuzzy-finder-60337ef08060)
- [A helpful doc on how to migrate to LUA](https://github.com/nanotee/nvim-lua-guide), but it is helpful to just use `:h lua`
