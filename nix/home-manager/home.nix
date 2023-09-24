{ config, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "aignas";
  home.homeDirectory = "/home/aignas";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Manage dotfiles
  home.file = {
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

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/aignas/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  # home.sessionVariables = {
  #   # EDITOR = "e";
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
