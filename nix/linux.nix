{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./dotfiles.nix
    ./nvim.nix
    ./sway.nix
    ./xdg.nix
  ];


  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [ "claude-code" ];

  home.packages = [
    pkgs.claude-code
    pkgs.eza
    pkgs.opencode
    pkgs.opentofu
    pkgs.ruff
    pkgs.ty
    pkgs.watchexec

    # media
    pkgs.imv
  ];

  xdg.configFile = {
    "pacman/makepkg.conf".source = ../pacman/makepkg.conf;
  };

  home.username = "aignas";
  home.homeDirectory = "/home/aignas";
}
