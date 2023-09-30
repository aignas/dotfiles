{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "aignas";
  home.homeDirectory = "/home/aignas";

  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = [
    pkgs.aerc
    pkgs.eza
    pkgs.fzf
    pkgs.lf
    pkgs.fd
    pkgs.jq
    pkgs.newsboat

    # nvim dependencies
    pkgs.black
    pkgs.gopls
    pkgs.pyright
    pkgs.ruff
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.yamlfmt
    pkgs.yamllint

    # bazel and friends
    pkgs.buildifier
    pkgs.buildozer
    pkgs.bazelisk
  ];

  # Manage dotfiles
  home.file = {
    ".local/bin" = {
        source = ../../bin;
        recursive = true;
    };

    ".config/aerc/aerc.conf".source = ../../aerc/aerc.conf;
    ".config/aerc/binds.conf".source = ../../aerc/binds.conf;
    ".config/aerc/scripts" = {
        source = ../../aerc/scripts;
        recursive = true;
    };
    ".config/alacritty" = {
        source = ../../alacritty/alacritty;
        recursive = true;
    };
    ".config/gammastep" = {
        source = ../../xdg/gammastep;
        recursive = true;
    };
    ".config/i3status-rust" = {
        source = ../../xdg/i3status-rust;
        recursive = true;
    };
    ".config/kanshi" = {
        source = ../../xdg/kanshi;
        recursive = true;
    };
    ".config/lf" = {
        source = ../../lf/lf;
        recursive = true;
    };
    ".config/mimeapps.list".source = ../../xdg/mimeapps.list;
    ".config/newsboat" = {
        source = ../../xdg/newsboat;
        recursive = true;
    };
    # ".config/nvim" = {
    #     source = ../../neovim/nvim;
    #     recursive = false;
    # };
    ".config/pacman" = {
        source = ../../pacman/pacman;
        recursive = true;
    };
    ".config/qutebrowser" = {
        source = ../../qutebrowser/qutebrowser;
        recursive = true;
    };
    ".config/sway" = {
        source = ../../xdg/sway;
        recursive = true;
    };
    ".config/swayidle" = {
        source = ../../xdg/swayidle;
        recursive = true;
    };
    ".config/swaylock" = {
        source = ../../xdg/swaylock;
        recursive = true;
    };
    ".config/user-dirs.dirs".source = ../../xdg/user-dirs.dirs;
    ".config/user-dirs.locale".source = ../../xdg/user-dirs.locale;
    ".gitconfig".source = ../../git/dot-gitconfig;
    ".gitconfig.local".source = ../../git/dot-gitconfig.local;
    ".tmux".source = ../../tmux/dot-tmux;
    ".tmux.conf".source = ../../tmux/dot-tmux.conf;
    ".zshenv".source = ../../zsh/dot-zshenv;
    ".zshrc".source = ../../zsh/dot-zshrc;
  };

  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
