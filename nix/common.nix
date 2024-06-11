{ config, pkgs, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> {};
in

{
  manual.html.enable = false;
  manual.manpages.enable = false;
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
    pkgs.tig
    pkgs.kind

    # mail
    pkgs.newsboat
    pkgs.aerc
    pkgs.dante
    pkgs.w3m
    pkgs.translate-shell

    # nvim dependencies
    pkgsUnstable.buf
    pkgsUnstable.deno
    pkgsUnstable.gopls
    pkgsUnstable.lua5_4_compat
    pkgsUnstable.pyright
    pkgsUnstable.ruff
    pkgsUnstable.ruff-lsp
    pkgsUnstable.rust-analyzer
    pkgsUnstable.shellcheck
    pkgsUnstable.shfmt
    pkgsUnstable.uv
    pkgsUnstable.yamlfmt
    pkgsUnstable.yamllint

    # bazel and friends
    pkgs.buildifier
    pkgs.buildozer
    pkgs.bazelisk
    # TODO @aignas 2024-05-04: this is currently not building with nix properly
    #pkgs.bazel-watcher

    # blog
    pkgs.zola
  ];

  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
