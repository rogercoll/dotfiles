{ ... }:
{
  programs.tmux = {
    enable = true;
    extraConfig = ''
      # Enable mouse input
      setw -g mouse on

      # Open/split window in the current directory
      bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # Set status background color
      set -g status-style "bg=#90a959,fg=#262626"
    '';
  };
}
