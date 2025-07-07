{ config, pkgs, ... }:

{
  xdg = {
    configFile = {
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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withPython3 = true;
    extraPackages = with pkgs; [
      buf
      gopls
      lua5_4_compat
      pyright
      ruff
      rust-analyzer
      shellcheck
      shfmt
      starpls
      tree-sitter
      yamlfmt
      yamllint
    ];
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      nvim-treesitter.withAllGrammars
    ];
  };
}
