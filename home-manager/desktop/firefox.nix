{ config, ... }:
{
  # Create "~/downloads" directory.
  home.file."Downloads/.keep".text = "";

  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";

    profiles.main = {
      id = 0;
      isDefault = true;
      settings = {
        # Never ask to remember passwords
        "signon.rememberSignons" = false;
        # Set download directory
        "browser.download.dir" = "/home/${config.home.username}/Downloads";
      };
    };
  };
}
