{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./sway.nix
  ];

  home.username = "aignas";
  home.homeDirectory = "/home/aignas";
}
