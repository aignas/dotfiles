{ config, pkgs, ... }:

{
  manual.html.enable = false;
  manual.manpages.enable = false;
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = [
    pkgs.asdf
    pkgs.curl
    pkgs.direnv
    pkgs.fd
    pkgs.fzf
    pkgs.ghostscript
    pkgs.github-cli
    pkgs.htop
    pkgs.jq
    pkgs.kind
    pkgs.lf
    pkgs.opentofu
    pkgs.pre-commit
    pkgs.ripgrep
    pkgs.terraform-docs
    pkgs.terragrunt
    pkgs.tig

    # mail
    #pkgs.aerc
    #pkgs.dante
    #upkgs.w3m
    #pkgs.translate-shell

    # nvim dependencies
    pkgs.buf
    pkgs.gopls
    pkgs.lua5_4_compat
    pkgs.pyright
    pkgs.ruff
    pkgs.rust-analyzer
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.uv
    pkgs.yamlfmt
    pkgs.yamllint

    # bazel and friends
    pkgs.bazelisk

    # blog
    pkgs.zola
  ];

  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
