{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./dotfiles.nix
    ./nvim.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ignas.anikevicius";
  home.homeDirectory = "/Users/ignas.anikevicius";

  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = [
    pkgs.eza
    pkgs.opentofu
    pkgs.terragrunt
    pkgs.tflint
    pkgs.kind
    pkgs.kubectl
    pkgs.postgresql # for psql CLI tool
  ];
}
