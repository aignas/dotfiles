{ config, pkgs, ... }:

{
  xdg = {
    enable = true;

    configFile = {
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
  };
}
