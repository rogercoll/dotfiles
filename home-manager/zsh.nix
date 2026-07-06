{
  config,
  osConfig,
  lib,
  pkgs,
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

      # ls
      ls = "lsd";
      l = "lsd -l";
      ll = "lsd -lahF";
      lls = "lsd -lahFtr";
      la = "lsd -A";
      lc = "lsd -CF";
      lt = "lsd --tree";

      # safety
      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -iv";

      # replacements
      cat = "bat --style header-filesize,header-filename";

      # nvim (function defined in initContent)
      nvim = "nvim_launch";
      n = "nvim_launch";
      vi = "nvim_launch";
      vim = "nvim_launch";

      # network
      myip = "curl ifconfig.co";
      weather = "curl wttr.in/barcelona?1";
      arch = "uname -m";

      # go
      got = "go test -v ./...";

      # k8s
      k = "kubectl";
      kgp = "kubectl get pods";

      # navigation
      cdgh = "cd /home/neck/Documents/github/rogercoll/";
      cdd = "cd /home/neck/Documents/";
      cddot = "cd /home/neck/Documents/github/rogercoll/dotfiles/";

      # misc
      mkt = "mkdir nmap scripts targets";
      pscount = "ps -eo s,comm,wchan | sort | uniq -c | sort -nbr | head";
    };

    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.zsh_history";
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
      append = true;
    };

    initContent = lib.mkMerge [
      # History setopts not covered by programs.zsh.history
      (lib.mkBefore ''
        setopt HIST_NO_FUNCTIONS
        setopt HIST_NO_STORE
        setopt HIST_REDUCE_BLANKS
        setopt HIST_SAVE_NO_DUPS
      '')

      # Functions
      ''
        function nvim_launch {
          declare -a args

          if [[ $# -gt 0 ]]; then
            local path_arg="$1"
            shift
            elements=(''${(s/:/)path_arg})
            local file=''${elements[@]:0:1}
            args+=($file)
            local line_num=''${elements[@]:1:1}
            if (( line_num )); then
              args+=("+$line_num")
            fi
            args+=($@)
          fi

          \nvim $args
        }

        function port {
          local p=$1
          if [ -z "$p" ]; then
            echo "port() - determine which process is using a port"
            echo "Usage: port <port number>"
            return
          fi
          lsof -i :$p
        }

        function ksh {
          local p=$1
          if [ -z "$p" ]; then
            echo "ksh() - run a bash shell in a k8s pod"
            echo "Usage: ksh <pod id>"
            return
          fi
          kubectl exec --stdin --tty $p -- /bin/bash
        }

        function vmrss {
          if [ -z "$1" ]; then
            echo "vmrss() - determine how much resident virtual memory a process is using"
            echo "Usage: vmrss <pid>"
            return
          fi

          declare -a arr
          arr=("$1" 0)
          local total=0

          while [[ ''${#arr[@]} -gt 0 ]]; do
            local space=''${arr[-1]}
            local pid=''${arr[-2]}
            arr=("''${arr[@]:1:''${#arr[@]}-2}")

            [[ -d "/proc/$pid" ]] || continue

            local mem=$(grep VmRSS /proc/$pid/status | grep -o '[0-9]\+' | awk '{print $1/1024}')
            total=$(echo $mem+$total | bc)
            local name=$(ps -p $pid -o comm=)
            printf "%''${space}s%s($pid): $mem MB\n" "" "$name"

            local children=$(pgrep -P $pid)
            for child in $children; do
              arr+=("$child" $((space+2)))
            done
          done
          printf "Total: $total MB\n"
        }

        function flacky {
          local command=$1
          if [ -z "$command" ]; then
            echo "flacky() - run command until it fails"
            echo "Usage: flacky <command>"
            return
          fi
          while true; do
            output=$(bash -c "$command" 2>&1)
            exit_code=$?
            if [ $exit_code -ne 0 ]; then
              echo "Command failed with exit code: $exit_code"
              echo "Output of the failed execution:"
              echo "$output"
              exit $exit_code
            fi
            echo "Command succeeded, running again..."
          done
        }

      ''

      # ZLE widgets
      ''
        autoload -Uz edit-command-line
        zle -N edit-command-line
        bindkey '^X^E' edit-command-line

        function clear-screen-and-scrollback() {
          echoti civis >"$TTY"
          printf '%b' '\e[H\e[2J\e[3J' >"$TTY"
          echoti cnorm >"$TTY"
          zle redisplay
        }
        zle -N clear-screen-and-scrollback
        bindkey '^X^X' clear-screen-and-scrollback
      ''

      # Completion
      ''
        bindkey ' ' magic-space
        zmodload zsh/complist

        bindkey -M menuselect 'h' vi-backward-char
        bindkey -M menuselect 'k' vi-up-line-or-history
        bindkey -M menuselect 'j' vi-down-line-or-history
        bindkey -M menuselect 'l' vi-forward-char
        bindkey -M menuselect '^xg' clear-screen
        bindkey -M menuselect '^xi' vi-insert
        bindkey -M menuselect '^xh' accept-and-hold
        bindkey -M menuselect '^xn' accept-and-infer-next-history
        bindkey -M menuselect '^xu' undo

        _comp_options+=(globdots)

        setopt MENU_COMPLETE
        setopt AUTO_LIST
        setopt COMPLETE_IN_WORD

        zstyle ':completion:*' completer _extensions _complete _approximate
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
        zstyle ':completion:*' complete true
        zle -C alias-expension complete-word _generic
        bindkey '^Xa' alias-expension
        zstyle ':completion:alias-expension:*' completer _expand_alias
        zstyle ':completion:*' menu select
        zstyle ':completion:*' complete-options true
        zstyle ':completion:*' file-sort modification
        zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
        zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
        zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
        zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
        zstyle ':completion:*:*:*:*:default' list-colors ''${(s.:.)LS_COLORS}
        zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
        zstyle ':completion:*' group-name ""
        zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands
        zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
        zstyle ':completion:*' keep-prefix true
        zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(''${=''${''${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
      ''

      # Global and suffix aliases
      ''
        alias -g NE='2>/dev/null'
        alias -g NO='>/dev/null'
        alias -g NUL='>/dev/null 2>&1'
        alias -g STANY='2>&1'
        alias -s go='$EDITOR'
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
        [](fg:${surface})$username''${custom.hostname}[](fg:${surface} bg:${info})$directory[](fg:${info} bg:${warning})''${custom.vcs}[](fg:${warning})
        [  ](fg:${foreground})
      '';

      add_newline = true;

      username = {
        show_always = true;
        style_user = "fg:${foreground} bg:${surface}";
        style_root = "fg:${error} bg:${surface}";
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
          symbol = "<U+F418>";
          style = "fg:${background} bg:${warning}";
          format = "[ $symbol $output ]($style)";
        };
      };
    };
  };
}
