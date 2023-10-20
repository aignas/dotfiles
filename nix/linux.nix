{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./dotfiles.nix
    ./sway.nix
  ];


  home.packages = [
    pkgs.eza
    pkgs.opentofu

    # media
    pkgs.imv
    pkgs.youtube-dl
  ];

  xdg.configFile = {
    "pacman/makepkg.conf".source = ../pacman/makepkg.conf;
  };

  home.username = "aignas";
  home.homeDirectory = "/home/aignas";
}
