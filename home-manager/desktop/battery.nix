{ pkgs, ... }:
{
  systemd.user.services.battery-monitor = {
    Unit = {
      Description = "Battery monitoring";
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeScript "battery-monitor.sh" ''
        #!${pkgs.bash}/bin/bash
        BATTERY_DIR=$(ls -d /sys/class/power_supply/BAT* | head -n 1)
        if test -z "$BATTERY_DIR"; then
            exit 0
        fi

        FLAG_FILE_PREFIX="/tmp/battery-monitor"

        STATUS=$(cat "$BATTERY_DIR/status")
        if test "$STATUS" != "Discharging"; then
            rm $FLAG_FILE_PREFIX*
            exit 0
        fi

        CAPACITY=$(cat "$BATTERY_DIR/capacity")
        if test "$CAPACITY" -le 5; then
            ${pkgs.libnotify}/bin/notify-send -a battery-monitor -u critical "󱐋 Battery critically low" "$CAPACITY% remaining"
        elif test "$CAPACITY" -le 15; then
            FLAG_FILE=$FLAG_FILE_PREFIX.battery-very-low.flagfile
            if test ! -f "$FLAG_FILE"; then
                ${pkgs.libnotify}/bin/notify-send -a battery-monitor -u critical "󱐋 Battery very low" "$CAPACITY% remaining"
                touch "$FLAG_FILE"
            fi
        elif test "$CAPACITY" -le 30; then
            FLAG_FILE=$FLAG_FILE_PREFIX.battery-low.flagfile
            if test ! -f "$FLAG_FILE"; then
                ${pkgs.libnotify}/bin/notify-send -a battery-monitor -u critical "󱐋 Battery low" "$CAPACITY% remaining"
                touch "$FLAG_FILE"
            fi
        else
            rm $FLAG_FILE_PREFIX*
        fi
      '';
    };
  };

  systemd.user.timers.battery-monitor = {
    Unit = {
      Description = "Run battery check once per minute";
    };
    Timer = {
      OnBootSec = "0s";
      OnUnitActiveSec = "1m";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
