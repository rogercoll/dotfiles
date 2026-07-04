{
  config,
  osConfig,
  lib,
  ...
}:
let
  withNiri = osConfig.programs.niri.enable;

  accent = config.theme.colors.accent;
  success = config.theme.colors.success;
  info = config.theme.colors.info;
  warning = config.theme.colors.warning;
  error = config.theme.colors.error;
  background = config.theme.colors.background;
  surface = config.theme.colors.surface;
  foreground = config.theme.colors.foreground;
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;

    syntaxHighlighting = {
      enable = true;
      styles = {
        alias = "fg=${success}";
        builtin = "fg=${success}";
        function = "fg=${success}";
        command = "fg=${success}";
        hashed-command = "fg=${success}";
        arg0 = "fg=${success}";
        precommand = "fg=${accent}";
        globbing = "fg=${info},bold";
        reserved-word = "fg=${warning}";
        redirection = "fg=${warning}";
        unknown-token = "fg=${error}";
        path = "fg=${info},underline";
        comment = "fg=${surface}";
        default = "fg=${foreground}";
      };
    };

    shellAliases = {
      gc = "sudo nix-collect-garbage -d";
      cheatsheet = ''
        echo "Bluetooth"
        echo "  systemctl [status|start|stop] bluetooth"
        echo "  bluetoothctl"
        echo "Network"
        echo "  nmcli connection show"
        echo "  nmcli device wifi connect \"<wifi name>\" [password \"<password>\"]"
      '';
    };

    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";

    initContent = lib.mkMerge [
      ''
        autoload -U colors && colors
        PROMPT='╭─ %F{${success}}%n@%m%f %F{${info}}%~%f
        ╰─ '
      ''
      (lib.mkIf withNiri ''
        if [[ 
          "$(tty)" == "/dev/tty1" 
          && "$XDG_SESSION_TYPE" == "tty" 
          && -z "$XDG_CURRENT_DESKTOP" 
          && -z "$WAYLAND_DISPLAY" 
        ]]; then
          exec niri-session
        fi;
      '')
    ];

  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      format = ''
        [](fg:${surface})$username''${custom.hostname}[](fg:${surface} bg:${info})$directory[](fg:${info} bg:${warning})''${custom.vcs}[](fg:${warning})
        [  ](fg:${foreground})
      '';

      add_newline = true;

      username = {
        show_always = true;
        style_user = "fg:${foreground} bg:${surface}";
        style_root = "fg:${error} bg:${surface}";
        # Do not add any space after $user, it is set after $custom.hostname.
        format = "[ $user]($style)";
        disabled = false;
      };

      directory = {
        style = "fg:${background} bg:${info}";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      custom = {
        hostname = {
          when = "true";
          command = ''
            if [ ! -z "$SSH_CLIENT" ]; then
              echo @$HOST;
            fi
          '';

          style = "fg:${info} bg:${surface}";
          # Do not add any space before $output, hostname comes after $username.
          format = "[$output ]($style)";
        };

        vcs = {
          when = "[[ -d .jj || -d .git ]]";
          detect_folders = [
            ".jj"
            ".git"
          ];

          command = ''
            if [ -d .jj ]; then
                BOOKMARK=$(jj log -r 'closest_bookmark(@)' --template 'self.local_bookmarks()' --color=never --no-graph --ignore-working-copy)
                OFFSET=$(jj log -r 'closest_bookmark(@)+::@' -T '"n"' --color=never --no-graph --ignore-working-copy 2>/dev/null | wc -c)
                if [ "$OFFSET" -gt 0 ]; then
                  BOOKMARK="$BOOKMARK +$OFFSET"
                fi
                
                echo $BOOKMARK
            else
                git branch --show-current
            fi
          '';
          symbol = "";
          style = "fg:${background} bg:${warning}";
          format = "[ $symbol $output ]($style)";
        };
      };
    };
  };
}
