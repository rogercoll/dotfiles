{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.desktopEnvironment = with lib; {
    displayManager = mkOption {
      type = types.enum [
        "greet"
        "ly"
        "sddm"
        "none"
      ];
    };

    sessions = mkOption {
      type = types.nonEmptyListOf (
        types.enum [
          "niri"
          "plasma"
        ]
      );
    };
  };

  imports = [
    ./greetd.nix
    ./ly.nix
    ./sddm.nix
  ];

  config = with config.desktopEnvironment; {
    # Disable the X11 windowing system.
    services.xserver.enable = false;

    # Display manager.
    displayManager.sddm.enable = displayManager == "sddm";
    displayManager.ly.enable = displayManager == "ly";
    displayManager.greetd.enable = displayManager == "greet";

    # Desktop environment.
    services.desktopManager.plasma6.enable = builtins.elem "plasma" sessions;
    programs.niri.enable = builtins.elem "niri" sessions;

    # Enable Dconf for GTK apps.
    programs.dconf.enable = true;

    fonts.fontconfig.defaultFonts.monospace = [
      "JetBrains Mono Medium"
    ];

    environment.sessionVariables = {
      # Force Electron apps to use the Wayland backend natively.
      NIXOS_OZONE_WL = "1";
    };

    # Allow screensharing.
    security.rtkit.enable = true;
  };
}
