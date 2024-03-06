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

  xdg.enable = true;
  xdg.configFile = {
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
