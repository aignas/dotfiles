{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./dotfiles.nix
    ./nvim.nix
    ./sway.nix
  ];


  home.packages = [
    pkgs.eza
    pkgs.opentofu
    pkgs.watchexec

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
