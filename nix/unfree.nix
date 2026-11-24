# Collect the allowed unfree packages from all modules instead of having a
# single allowUnfreePredicate that only one module can set.
{ config, lib, ... }:

{
  options.dotfiles.allowUnfree = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Names of the unfree packages that are allowed to be installed.";
  };

  config.nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) config.dotfiles.allowUnfree;
}
