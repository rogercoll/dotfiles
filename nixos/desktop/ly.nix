{ config, lib, ... }:
{
  options.displayManager.ly = with lib; {
    enable = mkEnableOption "ly";
  };

  config =
    with config.displayManager;
    lib.mkIf ly.enable {
      services.displayManager.ly = {
        enable = true;
        x11Support = false;
        settings = {
          asterisk = "0x2022";
          clear_password = true;
          default_input = "password";
          auth_fails = 3;
          session_log = ".local/state/ly-session.log";
        };
      };
    };
}
