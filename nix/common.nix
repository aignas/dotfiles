{ config, pkgs, ... }:

{
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    curl
    diskonaut
    eza
    fd
    fzf
    github-cli
    htop
    jq
    lf
    pre-commit
    ripgrep

    # mail
    newsboat
    aerc
    dante
    w3m
    translate-shell

    # nvim dependencies
    black
    buf
    gopls
    pyright
    ruff
    shellcheck
    shfmt
    skk-dicts
    yamlfmt
    yamllint

    # bazel and friends
    buildifier
    buildozer
    bazelisk

    # generic dev deps
    direnv
    opentofu
    terragrunt
    tflint
    kubectl

    # media
    imv
    youtube-dl
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
