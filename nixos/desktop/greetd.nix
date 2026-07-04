{
  config,
  lib,
  pkgs,
  ...
}:
let
  # An intermediary user/group to execute tuigreet.
  tuigreet = rec {
    user = "greeter";
    group = user;
  };
in
{
  options.displayManager.greetd = with lib; {
    enable = mkEnableOption "greetd";
  };

  config =
    with config.displayManager;
    lib.mkIf greetd.enable {
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            user = "${tuigreet.user}";
            command = ''
              ${pkgs.tuigreet}/bin/tuigreet \
              --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions \
              --remember \
              --xsessions \ # ${config.services.displayManager.sessionData.desktops}/share/xsessions \
              --remember-user-session \
              --time 
            '';
          };
        };
      };

      systemd = {
        services.greetd.serviceConfig = {
          Type = "idle";
          StandardInput = "tty";
          StandardOutput = "tty";
          StandardError = "journal";
          # Without this bootlogs will spam on screen
          TTYReset = true;
          TTYVHangup = true;
          TTYVTDisallocate = true;
        };

        tmpfiles.rules = [
          # Cache directory must be created for --remember* features to work.
          "d /var/cache/tuigreet 0755 ${tuigreet.user} ${tuigreet.group} -"
        ];
      };
    };
}
