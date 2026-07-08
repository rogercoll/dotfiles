{ pkgs, ... }:
{

  home.packages = with pkgs; [
    kdePackages.dolphin
  ];

  xdg.configFile."dolphinrc".text = ''
    [UiSettings]
    ColorScheme=BreezeDark
  '';
}
