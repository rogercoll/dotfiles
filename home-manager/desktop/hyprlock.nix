{ config, lib, ... }:
let
  accent = lib.removePrefix "#" config.theme.colors.accent;
  warning = lib.removePrefix "#" config.theme.colors.warning;
  error = lib.removePrefix "#" config.theme.colors.error;
  surface = lib.removePrefix "#" config.theme.colors.surface;
  foreground = lib.removePrefix "#" config.theme.colors.foreground;
  foreground-muted = lib.removePrefix "#" config.theme.colors.foreground-muted;
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        path = "screenshot";
        blur_passes = 3;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };

      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      label = [
        {
          text = ''cmd[update:1000] echo -e "$(date +"%A, %B %d")"'';
          color = "rgb(${foreground})";
          font_size = 25;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 250";
          halign = "center";
          valign = "center";
        }
        {
          text = ''cmd[update:1000] echo "<span>$(date +"%H:%M")</span>"'';
          color = "rgb(${foreground})";
          font_size = 120;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 150";
          halign = "center";
          valign = "center";
        }
        {
          text = "$USER";
          color = "rgb(${foreground})";
          font_size = 18;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, -130";
          halign = "center";
          valign = "center";
        }
        {
          text = "<span size='14pt'> </span>$LAYOUT";
          color = "rgb(${foreground-muted})";
          font_size = 12;
          font_family = "Noto Sans";
          position = "0, 50";
          halign = "center";
          valign = "bottom";
        }
      ];

      shape = {
        size = "300, 60";
        color = "rgba(0, 0, 0, 0)";
        rounding = 20;
        border_size = 2;
        border_color = "rgb(${foreground})";
        rotate = 0;
        xray = false;

        position = "0, -130";
        halign = "center";
        valign = "center";
      };

      input-field = {
        size = "300, 60";
        rounding = 20;

        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgb(${surface})";
        font_color = "rgb(${foreground})";
        capslock_color = "rgb(${warning})";
        check_color = "rgb(${accent})";
        fail_color = "rgb(${error})";

        fade_on_empty = false;
        font_family = "JetBrainsMono Nerd Font";
        placeholder_text = ''<i><span foreground="#${config.theme.colors.foreground-disabled}">Enter password</span></i>'';
        hide_input = false;
        position = "0, -210";
        halign = "center";
        valign = "center";
      };
    };
  };
}
