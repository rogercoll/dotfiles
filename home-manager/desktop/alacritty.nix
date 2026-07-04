{ config, pkgs, ... }:
let
  accent = config.theme.colors.accent;
  success = config.theme.colors.success;
  info = config.theme.colors.info;
  warning = config.theme.colors.warning;
  error = config.theme.colors.error;
  background = config.theme.colors.background;
  surface = config.theme.colors.surface;
  foreground = config.theme.colors.foreground;
  foreground-muted = config.theme.colors.foreground-muted;
in
{
  # Enable alacritty terminal.
  programs.alacritty = {
    enable = true;
    settings = {
      # Execute tmux on startup.
      terminal.shell.program = "tmux";

      font = {
        size = 12.0;
        normal = {
          family = "JetBrainsMonoNLNerdFont";
          style = "Regular";
        };
        italic = {
          style = "Italic";
        };
        bold = {
          style = "ExtraBold";
        };
        bold_italic = {
          style = "ExtraBoldItalic";
        };
      };
      window = {
        padding = {
          x = 4;
          y = 2;
        };
      };
      colors = {
        primary = {
          background = "${background}";
          foreground = "${foreground}";
          dim_foreground = "${foreground-muted}";
        };

        normal = {
          black = "${surface}";
          red = "${error}";
          green = "${success}";
          yellow = "${warning}";
          blue = "${info}";
          magenta = "${accent}";
          cyan = "${info}";
          white = "${foreground}";
        };
      };
    };
  };

  home.packages = with pkgs; [
    fastfetch
    tmux
  ];
}
