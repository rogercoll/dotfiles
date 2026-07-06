{ pkgs, config, ... }:
{
  home.packages = [ pkgs.xclip ];

  programs.tmux = {
    enable = true;
    prefix = "C-t";
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      resurrect
    ];

    extraConfig = ''
      # 24-bit color
      set-option -sa terminal-overrides ",xterm*:Tc"

      # Status bar
      set -g status-style "bg=${config.theme.colors.surface},fg=${config.theme.colors.foreground}"
      set -g status-left-style "fg=${config.theme.colors.accent},bold"
      set -g window-status-current-style "fg=${config.theme.colors.info},bold"

      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on
      set-option -g repeat-time 0

      # Open windows/splits in current path
      bind c new-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"

      # Copy to system clipboard
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel "xclip -selection clipboard -in"

      # Days since 2024-01-30
      set -g status-right '#(python3 -c "from datetime import datetime; d1 = datetime(2024, 1, 30); d2 = datetime.now(); print((d2 - d1).days)")'
      set -g status-interval 3600
    '';
  };
}
