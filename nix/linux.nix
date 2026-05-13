{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./dotfiles.nix
    ./nvim.nix
    ./sway.nix
    ./xdg.nix
  ];


  home.packages = [
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
