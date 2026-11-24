# Optional private extension of this configuration, e.g. employer-specific
# files and packages that must not end up in this public repo.
#
# bin/renix points DOTFILES_INTERNAL at ~/.dotfiles/internal (ignored by git)
# and evaluates with --impure when it exists. The flake itself cannot see the
# directory, as flakes only contain files that are tracked by git.
{ lib, ... }:

let
  dir = builtins.getEnv "DOTFILES_INTERNAL";
in
{
  imports = lib.optional (dir != "" && builtins.pathExists "${dir}/default.nix") (/. + dir);
}
