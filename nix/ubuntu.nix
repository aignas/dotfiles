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
    azure-cli
    buildifier
    eza
    i3status-rust
    kanshi # this is not ancient
    k9s
    mise
    opentofu
    python3Packages.jupytext
    terragrunt
    tflint
    watchexec
    yq-go

    # media
    imv
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
      "x-scheme-handler/slack" = "slack_slack.desktop";
      "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
    };
  };

  home.username = "ignas-anikevicius";
  home.homeDirectory = "/home/ignas-anikevicius";
}
