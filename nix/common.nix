{ config, pkgs, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> {};
in

{
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = [
    pkgs.curl
    pkgs.diskonaut
    pkgsUnstable.eza
    pkgs.fd
    pkgs.fzf
    pkgs.ghostscript
    pkgs.github-cli
    pkgs.htop
    pkgs.jq
    pkgs.lf
    pkgs.pre-commit
    pkgs.ripgrep

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

    # generic dev deps
    pkgs.direnv
    pkgsUnstable.opentofu
    pkgs.terragrunt
    pkgs.tflint
    pkgs.kubectl
    pkgs.postgresql # for psql CLI tool
  ];

  # Manage dotfiles
  home.file = {
    ".local/bin" = {
      source = ../bin;
      recursive = true;
    };

    ".gitconfig".source = ../git/gitconfig;
    ".gitconfig.local".source = ../git/gitconfig.local;
    ".tmux".source = ../tmux/tmux;
    ".tmux.conf".source = ../tmux/tmux.conf;
    ".zshenv".source = ../zsh/zshenv;
    ".zshrc".source = ../zsh/zshrc;
  };

  xdg = {
    enable = true;

    configFile = {
      "aerc/aerc.conf".source = ../aerc/aerc.conf;
      "aerc/binds.conf".source = ../aerc/binds.conf;
      "aerc/scripts/wait-for-creds.sh" = {
        source = ../aerc/scripts/wait-for-creds.sh;
        executable = true;
      };
      "alacritty/alacritty.yml".source = ../alacritty/alacritty.yml;
      "lf/lfrc".source = ../lf/lfrc;
      "newsboat/config".source = ../newsboat/config;
      "newsboat/urls".source = ../newsboat/urls;
      "nvim" = {
        source = ../neovim/nvim;
        recursive = false;
      };
      "pacman/makepkg.conf".source = ../pacman/makepkg.conf;
    };

    dataFile = {
      "nvim/backup/.keep".text = "";
      "nvim/swap/.keep".text = "";
      "nvim/undo/.keep".text = "";
    };
  };

  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
