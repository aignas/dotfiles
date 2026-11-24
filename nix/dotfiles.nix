{ config, lib, pkgs, ... }:

{
  options.dotfiles.claudeMd = lib.mkOption {
    type = lib.types.lines;
    description = ''
      Contents of ~/.claude/CLAUDE.md. Definitions from several modules are
      concatenated, so that e.g. the private extension can append to it.
    '';
  };

  config.dotfiles.claudeMd = builtins.readFile ../claude/CLAUDE.md;

  # Manage dotfiles
  config.home.file = {
    ".local/bin" = {
      source = ../bin;
      recursive = true;
    };

    ".claude/CLAUDE.md".text = config.dotfiles.claudeMd;
    ".gitconfig".source = ../git/gitconfig;
    ".tmux".source = ../tmux/tmux;
    ".tmux.conf".source = ../tmux/tmux.conf;
    ".zshenv_local".source = ../zsh/zshenv;
    ".zshrc".source = ../zsh/zshrc;
  };

  config.xdg.enable = true;
  config.xdg.configFile = {
    "aerc/aerc.conf".source = ../aerc/aerc.conf;
    "aerc/binds.conf".source = ../aerc/binds.conf;
    "aerc/scripts/wait-for-creds.sh" = {
      source = ../aerc/scripts/wait-for-creds.sh;
      executable = true;
    };
    "alacritty/alacritty.toml".source = ../alacritty/alacritty.toml;
    "lf/lfrc".source = ../lf/lfrc;
    "newsboat/config".source = ../newsboat/config;
    "newsboat/urls".source = ../newsboat/urls;
  };
}
