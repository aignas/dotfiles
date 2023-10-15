{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    i3status-rust
    zathura
  ];

  xdg = {
    enable = true;

    configFile = {
        "gammastep/config.ini"     .source = ../gammastep/config.ini;
        "i3status-rust/config.toml".source = ../i3status-rust/config.toml;
        "kanshi/config"            .source = ../kanshi/config;
        "qutebrowser/config.py"    .source = ../qutebrowser/config.py;
        "sway/bg.png"              .source = ../sway/james-webb-1.png;
        "sway/config"              .source = ../sway/config;
        "swayidle/config"          .source = ../swayidle/config;
        "swaylock/config"          .source = ../swaylock/config;
        "swaylock/lock.sh" = {
          source = ../swaylock/lock.sh;
          executable = true;
        };
        "swaylock/inhibitor/pulse.sh" = {
          source = ../swaylock/inhibitor/pulse.sh;
          executable = true;
        };
        "user-dirs.locale".text = "C";
    };

    userDirs = {
      enable = true;
      createDirectories = true;

      desktop = "${config.home.homeDirectory}/desktop";
      documents = "${config.home.homeDirectory}/docs";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/photo";
      publicShare = null;
      templates = null;
      videos = "${config.home.homeDirectory}/photo";
    };

    mimeApps = {
      enable = true;
      associations.added = {
        "image/tiff" = ["darktable.desktop" "imv.desktop"];
        "image/jpeg" = ["imv.desktop"];
      };

      defaultApplications = {
        "text/html" = ["org.qutebrowser.qutebrowser.desktop"];
        "x-scheme-handler/http" = ["org.qutebrowser.qutebrowser.desktop"];
        "x-scheme-handler/https" = ["org.qutebrowser.qutebrowser.desktop"];
        "x-scheme-handler/about" = ["org.qutebrowser.qutebrowser.desktop"];
        "x-scheme-handler/unknown" = ["org.qutebrowser.qutebrowser.desktop"];
        "application/pdf" = ["org.pwmt.zathura.desktop"];
      };
    };
  };
}
