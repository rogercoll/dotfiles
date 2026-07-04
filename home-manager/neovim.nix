{
  config,
  lib,
  name,
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
  };

  xdg.configFile."nvim/" = {
    source = ../neovim;
    recursive = true;
    # Clean up compiled lua files. This is a workaround for lazy.nvim not recompiling when symlinks change.
    onChange = "rm -f ${config.xdg.cacheHome}/nvim/luac/%2fhome%2f${name}%2f.config*.luac";
  };

  home.sessionVariables = with pkgs; {
    EDITOR = lib.getExe neovim;
    VISUAL = lib.getExe neovim;
  };
}
