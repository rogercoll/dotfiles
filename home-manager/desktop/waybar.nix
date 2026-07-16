{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  withNiri = osConfig.programs.niri.enable;
in
{
  options.desktopEnvironment.wayBarScreen = lib.mkOption {
    type = lib.types.str;
  };

  config.home.packages = with pkgs; [
    brightnessctl
    networkmanagerapplet
    pavucontrol
  ];

  config.programs.waybar = {
    enable = true;
    settings = {
      mainBar = with lib; {
        reload_style_on_change = true;
        layer = "top";
        position = "top";
        height = 30;
        spacing = 1;
        margin = "0";
        output = config.desktopEnvironment.wayBarScreen;

        modules-left = mkMerge [
          [ "group/hardware" ]
          (mkIf withNiri [
            "niri/workspaces"
            "niri/window"
          ])
        ];

        modules-center = [ "clock" ];

        modules-right = [
          "group/audio"
          "backlight"
          "network"
          "battery"
          "group/session"
          "tray"
        ];

        "niri/workspaces" = mkIf withNiri {
          format = "{icon}";
          format-icons = {
            active = "󰄟";
            default = "󰄰";
          };
        };

        "niri/window" = mkIf withNiri {
          format = "<span color='#FFD700'> 󰚫 {title}</span>";
          rewrite = {
            "(.*) - Mozilla Firefox" = "🌎 $1";
            "(.*) - zsh" = "> [$1]";
          };
        };

        "custom/hardware-wrap" = {
          format = "󰘚";
          tooltip-format = "Resource Usage";
        };

        "group/hardware" = {
          orientation = "horizontal";
          drawer = {
            transition-duration = 500;
            transition-left-to-right = true;
          };
          modules = [
            "custom/hardware-wrap"
            "cpu"
            "memory"
            "temperature"
            "disk"
          ];
        };

        "custom/session-wrap" = {
          format = "<span color='#63a4ff'> 󰐥 </span>";
          tooltip-format = "Lock, Reboot, Shutdown";
        };

        "group/session" = {
          orientation = "horizontal";
          drawer = {
            transition-duration = 500;
            transition-left-to-right = true;
          };
          modules = [
            "custom/session-wrap"
            "custom/lock"
            "custom/reboot"
            "custom/power"
          ];
        };

        "custom/lock" = {
          format = "<span color='#00FFFF'> 󰌾 </span>";
          on-click = "loginctl lock-session";
          tooltip = true;
          tooltip-format = "Lock screen";
        };

        "custom/reboot" = {
          format = "<span color='#FFD700'> 󰑓 </span>";
          on-click = "systemctl reboot";
          tooltip = true;
          tooltip-format = "Reboot";
        };

        "custom/power" = {
          format = "<span color='#FF4040'> 󰐦 </span>";
          on-click = "systemctl poweroff";
          tooltip = true;
          tooltip-format = "Power Off";
        };

        clock = {
          format = "󰥔 {:%H:%M 󰃮 %B %d, %Y}";
          format-alt = "󰥔 {:%H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#d3c6aa'><b>{}</b></span>";
              days = "<span color='#e67e80'>{}</span>";
              weeks = "<span color='#a7c080'><b>W{}</b></span>";
              weekdays = "<span color='#7fbbb3'><b>{}</b></span>";
              today = "<span color='#dbbc7f'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        cpu = {
          format = "󰘚 {usage}%";
          tooltip = true;
          interval = 1;
          on-click = "alacritty -e htop";
        };

        memory = {
          format = "󰍛 {}%";
          interval = 1;
          on-click = "alacritty -e htop";
        };

        temperature = {
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = [
            "󱃃"
            "󰔏"
            "󱃂"
          ];
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        network = {
          format-wifi = "󰖩 {essid} ({signalStrength}%)";
          format-ethernet = "󰈀 {ifname}";
          format-linked = "󰈀 {ifname} (No IP)";
          format-disconnected = "󰖪 Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format = "{ifname}: {ipaddr}";
          on-click-right = "alacritty -e nmtui";
        };

        "group/audio" = {
          orientation = "inherit";
          drawer = {
            children-class = "audio";
            transition-duration = 400;
            transition-left-to-right = false;
          };
          modules = [ "pulseaudio#output" ];
        };


        "pulseaudio#output" = {
          format = "{icon} {volume}%";
          format-icons = [
            "<span size='14pt'>󰕿</span>"
            "<span size='14pt'>󰖀</span>"
            "<span size='14pt'>󰕾</span>"
          ];
          format-muted = "<span size='14pt'>󰝟</span>";
          tooltip = true;
          tooltip-format = "Volume: {volume}%\n{desc}";
          interval = 1;
          scroll-step = 0;
          reverse-scrolling = true;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "pavucontrol";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [
            "󰃞"
            "󰃟"
            "󰃠"
          ];
          on-scroll-up = "brightnessctl set +5%";
          on-scroll-down = "brightnessctl set 5%-";
        };

        disk = {
          interval = 30;
          format = "󰋊 {percentage_used}%";
          path = "/";
        };

        tray = {
          icon-size = 16;
          spacing = 5;
        };

        "power-profiles-daemon" = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            "power-saver" = "";
          };
        };
      };
    };

    style = ''
      /* Pastel TTY Colors */
      @define-color background #212121;
      @define-color background-light #3a3a3a;
      @define-color foreground #e0e0e0;
      @define-color black #5a5a5a;
      @define-color red #ff9a9e;
      @define-color green #b5e8a9;
      @define-color yellow #ffe6a7;
      @define-color blue #63a4ff;
      @define-color magenta #dda0dd;
      @define-color cyan #a3e8e8;
      @define-color white #ffffff;
      @define-color orange #ff8952;

      /* Module-specific colors */
      @define-color workspaces-color @foreground;
      @define-color workspaces-focused-bg @green;
      @define-color workspaces-focused-fg @cyan;
      @define-color workspaces-urgent-bg @red;
      @define-color workspaces-urgent-fg @black;

      /* Text and border colors for modules */
      @define-color mode-color @orange;
      @define-color group-hardware-color @blue;
      @define-color group-session-color @red;
      @define-color clock-color @blue;
      @define-color cpu-color @green;
      @define-color memory-color @magenta;
      @define-color temperature-color @yellow;
      @define-color temperature-critical-color @red;
      @define-color battery-color @cyan;
      @define-color battery-charging-color @green;
      @define-color battery-warning-color @yellow;
      @define-color battery-critical-color @red;
      @define-color network-color @blue;
      @define-color network-disconnected-color @red;
      @define-color pulseaudio-color @orange;
      @define-color pulseaudio-muted-color @red;
      @define-color wireplumber-color @orange;
      @define-color wireplumber-muted-color @red;
      @define-color backlight-color @yellow;
      @define-color disk-color @cyan;
      @define-color updates-color @orange;
      @define-color quote-color @green;
      @define-color idle-inhibitor-color @foreground;
      @define-color idle-inhibitor-active-color @red;
      @define-color power-profiles-daemon-color @cyan;
      @define-color power-profiles-daemon-performance-color @red;
      @define-color power-profiles-daemon-balanced-color @yellow;
      @define-color power-profiles-daemon-power-saver-color @green;

      * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font Propo";
          font-size: 14px;
          min-height: 0;
      }

      window#waybar {
          background-color: @background;
          color: @foreground;
      }

      #mode,
      #custom-hardware-wrap,
      #custom-session-wrap,
      #clock,
      #cpu,
      #memory,
      #temperature,
      #battery,
      #network,
      #pulseaudio,
      #wireplumber,
      #backlight,
      #disk,
      #power-profiles-daemon,
      #idle_inhibitor,
      #tray {
          padding: 0 10px;
          margin: 0 2px;
          border-bottom: 2px solid transparent;
          background-color: transparent;
      }

      #workspaces button {
          padding: 0 10px;
          background-color: transparent;
          color: @workspaces-color;
          margin: 0;
      }

      #workspaces button:hover {
          background: @background-light;
          box-shadow: inherit;
      }

      #workspaces button.focused {
          box-shadow: inset 0 -2px @workspaces-focused-fg;
          color: @workspaces-focused-fg;
          font-weight: 900;
      }

      #workspaces button.urgent {
          background-color: @workspaces-urgent-bg;
          color: @workspaces-urgent-fg;
      }

      #mode {
          color: @mode-color;
          border-bottom-color: @mode-color;
      }

      #custom-hardware-wrap {
          color: @group-hardware-color;
          border-bottom-color: @group-hardware-color;
      }

      #custom-session-wrap {
          color: @group-session-color;
          border-bottom-color: @group-session-color;
      }

      #clock {
          color: @clock-color;
          border-bottom-color: @clock-color;
      }

      #cpu {
          color: @cpu-color;
          border-bottom-color: @cpu-color;
      }

      #memory {
          color: @memory-color;
          border-bottom-color: @memory-color;
      }

      #temperature {
          color: @temperature-color;
          border-bottom-color: @temperature-color;
      }

      #temperature.critical {
          color: @temperature-critical-color;
          border-bottom-color: @temperature-critical-color;
      }

      #power-profiles-daemon {
          color: @power-profiles-daemon-color;
          border-bottom-color: @power-profiles-daemon-color;
      }

      #power-profiles-daemon.performance {
          color: @power-profiles-daemon-performance-color;
          border-bottom-color: @power-profiles-daemon-performance-color;
      }

      #power-profiles-daemon.balanced {
          color: @power-profiles-daemon-balanced-color;
          border-bottom-color: @power-profiles-daemon-balanced-color;
      }

      #power-profiles-daemon.power-saver {
          color: @power-profiles-daemon-power-saver-color;
          border-bottom-color: @power-profiles-daemon-power-saver-color;
      }

      #battery {
          color: @battery-color;
          border-bottom-color: @battery-color;
      }

      #battery.charging,
      #battery.plugged {
          color: @battery-charging-color;
          border-bottom-color: @battery-charging-color;
      }

      #battery.warning:not(.charging) {
          color: @battery-warning-color;
          border-bottom-color: @battery-warning-color;
      }

      #battery.critical:not(.charging) {
          color: @battery-critical-color;
          border-bottom-color: @battery-critical-color;
      }

      #network {
          color: @network-color;
          border-bottom-color: @network-color;
      }

      #network.disconnected {
          color: @network-disconnected-color;
          border-bottom-color: @network-disconnected-color;
      }

      #pulseaudio {
          color: @pulseaudio-color;
          border-bottom-color: @pulseaudio-color;
      }

      #pulseaudio.muted {
          color: @pulseaudio-muted-color;
          border-bottom-color: @pulseaudio-muted-color;
      }

      #wireplumber {
          color: @wireplumber-color;
          border-bottom-color: @wireplumber-color;
      }

      #wireplumber.muted {
          color: @wireplumber-muted-color;
          border-bottom-color: @wireplumber-muted-color;
      }

      #backlight {
          color: @backlight-color;
          border-bottom-color: @backlight-color;
      }

      #disk {
          color: @disk-color;
          border-bottom-color: @disk-color;
      }

      #idle_inhibitor {
          color: @idle-inhibitor-color;
          border-bottom-color: transparent;
      }

      #idle_inhibitor.activated {
          color: @idle-inhibitor-active-color;
          border-bottom-color: @idle-inhibitor-active-color;
      }

      #tray {
          background-color: transparent;
          padding: 0 10px;
          margin: 0 2px;
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          color: @red;
          border-bottom-color: @red;
      }
    '';
  };
}
