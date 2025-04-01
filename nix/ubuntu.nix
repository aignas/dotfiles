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
  ];

  home.username = "ignas-anikevicius";
  home.homeDirectory = "/home/ignas-anikevicius";
}
