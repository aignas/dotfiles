{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./sway.nix
  ];


  home.packages = [
    # media
    pkgs.imv
    pkgs.youtube-dl
  ];

  home.username = "aignas";
  home.homeDirectory = "/home/aignas";
}
