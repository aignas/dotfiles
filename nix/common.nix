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
    pkgs.tig
    pkgs.kind

    # mail
    pkgs.newsboat
    pkgs.aerc
    pkgs.dante
    pkgs.w3m
    pkgs.translate-shell

    # nvim dependencies
    pkgs.buf
    pkgs.deno
    pkgs.gopls
    pkgs.lua5_4_compat
    pkgs.pyright
    pkgs.ruff
    pkgs.ruff-lsp
    pkgs.rust-analyzer
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.skk-dicts
    pkgs.yamlfmt
    pkgs.yamllint

    # bazel and friends
    pkgs.buildifier
    pkgs.buildozer
    pkgs.bazelisk
    pkgs.bazel-watcher

    # blog
    pkgs.zola
  ];

  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
