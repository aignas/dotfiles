{ config, lib, pkgs, ... }:

let
  # Text files opened from the desktop (file manager, browser downloads, ...)
  # go to nvim running in alacritty.
  editorMimeTypes = [
    "application/json"
    "application/toml"
    "application/x-shellscript"
    "application/x-yaml"
    "application/xml"
    "text/csv"
    "text/markdown"
    "text/plain"
    "text/x-c"
    "text/x-go"
    "text/x-log"
    "text/x-python"
    "text/x-rust"
    "text/x-shellscript"
    "text/yaml"
  ];
in
{
  xdg.desktopEntries.nvim-alacritty = {
    name = "Neovim (Alacritty)";
    genericName = "Text Editor";
    # alacritty comes from the system package manager, so that it can use the
    # system GL drivers.
    exec = "alacritty --class nvim -e ${config.programs.neovim.finalPackage}/bin/nvim %F";
    terminal = false;
    icon = "nvim";
    categories = [ "Utility" "TextEditor" ];
    mimeType = editorMimeTypes;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = lib.genAttrs editorMimeTypes (_: "nvim-alacritty.desktop");
  };

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
    withRuby = false;
    extraPackages = with pkgs; [
      buf
      buildifier
      gopls
      lua5_4_compat
      rust-analyzer
      shellcheck
      shfmt
      starpls
      tree-sitter
      typescript-language-server
      vue-language-server
      yaml-language-server
      yamlfmt
      yamllint
    ];
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      nvim-treesitter.withAllGrammars
    ];
  };
}
