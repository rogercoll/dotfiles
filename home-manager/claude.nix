{ pkgs, ... }:
{

  home.packages = with pkgs; [
    claude-code
  ];

  home.file.".claude/settings.json" = {
    force = true;
    text = builtins.toJSON {
      enabledPlugins = {
        "gopls-lsp@claude-plugins-official" = true;
        "ponytail@ponytail" = true;
      };
      extraKnownMarketplaces = {
        ponytail = {
          source = {
            source = "github";
            repo = "DietrichGebert/ponytail";
          };
        };
      };
      theme = "dark";
      statusLine = {
        type = "command";
        command = "jq -r '\"[\\(.model.display_name)] \\(.context_window.used_percentage // 0)% context | $\\(.cost.total_cost_usd // 0) \\u001b[32m+\\(.cost.total_lines_added // 0)\\u001b[0m \\u001b[31m-\\(.cost.total_lines_removed // 0)\\u001b[0m\"'";
      };
    };
  };
}
