{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    avizo
    i3status-rust
    #zathura
  ];

  xdg = {
    configFile = {
        "gammastep/config.ini"      .source = ../gammastep/config.ini;
        "i3status-rust/config.toml" .source = ../i3status-rust/config.toml;
        "kanshi/config"             .source = ../kanshi/config;
        "qutebrowser/config.py"     .source = ../qutebrowser/config.py;
        "environment.d/10-sway.conf".source = ../sway/env.conf;
        "sway/bg.jpg"               .source = ../sway/james-webb-1.jpg;
        "sway/config"               .source = ../sway/config;
        "swayidle/config"           .source = ../swayidle/config;
        "swaylock/config"           .source = ../swaylock/config;
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

    # mimeApps = {
    #   enable = true;
    #   associations.added = {
    #     "image/tiff" = ["darktable.desktop" "imv.desktop"];
    #     "image/jpeg" = ["imv.desktop"];
    #   };

    #   defaultApplications = {
    #     "text/html" = ["org.qutebrowser.qutebrowser.desktop"];
    #     "x-scheme-handler/http" = ["org.qutebrowser.qutebrowser.desktop"];
    #     "x-scheme-handler/https" = ["org.qutebrowser.qutebrowser.desktop"];
    #     "x-scheme-handler/about" = ["org.qutebrowser.qutebrowser.desktop"];
    #     "x-scheme-handler/unknown" = ["org.qutebrowser.qutebrowser.desktop"];
    #     "application/pdf" = ["org.pwmt.zathura.desktop"];
    #   };
    # };
  };
}
