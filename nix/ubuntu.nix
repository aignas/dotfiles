{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./dotfiles.nix
    ./nvim.nix
    ./xdg.nix
    ./sway.nix
  ];


  home.packages = [
    pkgs.buildifier
    pkgs.eza
    pkgs.yq-go
    pkgs.k9s
    pkgs.opentofu
    pkgs.watchexec

    # media
    pkgs.imv
  ];

  home.username = "ignas-anikevicius";
  home.homeDirectory = "/home/ignas-anikevicius";
}
