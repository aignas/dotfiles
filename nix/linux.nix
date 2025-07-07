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
    pkgs.home-manager
    pkgs.opentofu
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
