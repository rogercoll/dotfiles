{ pkgs, config, ... }:
{
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
    ];

    extraConfig = ''
      bind-key C-t send-prefix
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
    '';
  };
}
