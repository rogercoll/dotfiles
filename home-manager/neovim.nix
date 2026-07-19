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
    extraPackages = with pkgs; [
      wakatime-cli
      # LSP servers (used by vim.lsp.enable in plugin/80-lsp.lua)
      gopls
      rust-analyzer
      zls
      yaml-language-server
      bash-language-server
      clang-tools
      lua-language-server
      # Formatters
      stylua
      gotools
      # Build tools for vim.pack plugins (e.g. telescope-fzf-native)
      gcc
      gnumake
    ];
    # Only treesitter is managed by Nix — parsers are pre-compiled, no :TSUpdate needed.
    # All other plugins are managed by vim.pack (Neovim 0.11+ built-in).
    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: with p; [
        json go rust c yaml java typescript
      ]))
    ];
  };

  xdg.configFile."nvim/" = {
    source = ../nvim;
    recursive = true;
    onChange = "rm -f ${config.xdg.cacheHome}/nvim/luac/%2fhome%2f${name}%2f.config*.luac";
  };

  home.sessionVariables = with pkgs; {
    EDITOR = lib.getExe neovim;
    VISUAL = lib.getExe neovim;
    MANPAGER = "nvim +Man!";
  };
}
