{ config, pkgs, ... }:

{
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = [
    pkgs.curl
    pkgs.diskonaut
    pkgs.fd
    pkgs.fzf
    pkgs.ghostscript
    pkgs.github-cli
    pkgs.htop
    pkgs.jq
    pkgs.lf
    pkgs.pre-commit
    pkgs.ripgrep
    pkgs.direnv

    # mail
    pkgs.newsboat
    pkgs.aerc
    pkgs.dante
    pkgs.w3m
    pkgs.translate-shell

    # nvim dependencies
    pkgs.black
    pkgs.buf
    pkgs.gopls
    pkgs.pyright
    pkgs.ruff
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.skk-dicts
    pkgs.yamlfmt
    pkgs.yamllint

    # bazel and friends
    pkgs.buildifier
    pkgs.buildozer
    pkgs.bazelisk
  ];

  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
