{ ... }:
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock --grace 10 ";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "niri msg action power-on-monitors";
      };

      listener = [
        {
          timeout = 300; # 5 mins
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330; # 5.5 mins
          on-timeout = "niri msg action power-off-monitors";
          on-resume = "niri msg action power-on-monitors";
        }
        {
          timeout = 900; # 15 mins
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
