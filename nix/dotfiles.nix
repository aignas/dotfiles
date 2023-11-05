{ config, pkgs, ... }:

{
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
      "alacritty/alacritty.yml".source = ../alacritty/light.yml;
      "lf/lfrc".source = ../lf/lfrc;
      "newsboat/config".source = ../newsboat/config;
      "newsboat/urls".source = ../newsboat/urls;
      "nvim" = {
        source = ../nvim;
        recursive = false;
      };
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
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    extraPackages = [
      pkgs.buf
      pkgs.deno
      pkgs.gopls
      pkgs.pyright
      pkgs.ruff
      pkgs.rust-analyzer
      pkgs.shellcheck
      pkgs.tree-sitter
      pkgs.shfmt
      pkgs.skk-dicts
      pkgs.yamlfmt
      pkgs.yamllint
      pkgs.lua5_4_compat
    ];
    plugins = [
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    ];
  };
}
