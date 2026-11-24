{ config, pkgs, ... }:

{
  xdg = {
    enable = true;

    configFile = {
        "user-dirs.locale".text = "C";
        # Desktop apps (e.g. browsers asking to become the default) replace
        # the link with a copy, which would block activation. The defaults
        # are managed by xdg.mimeApps, so overwrite the copy.
        "mimeapps.list".force = true;
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = false;

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
