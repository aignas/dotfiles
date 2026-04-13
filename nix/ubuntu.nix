{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ./dotfiles.nix
    ./nvim.nix
    ./xdg.nix
    ./sway.nix
  ];


  home.packages = with pkgs; [
    buildifier
    eza
    i3status-rust
    k9s
    mise
    opencode
    opentofu
    python3Packages.jupytext
    terragrunt
    watchexec
    yq-go

    # media
    imv
  ];

  home.username = "ignas-anikevicius";
  home.homeDirectory = "/home/ignas-anikevicius";
}
