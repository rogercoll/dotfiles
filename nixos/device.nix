{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.profile = with lib; {
    username = mkOption {
      type = types.nonEmptyStr;
    };
    shell = mkOption {
      type = types.enum [
        "bash"
        "zsh"
      ];
      default = "bash";
    };
  };

  config = with config.profile; {
    # Allow unfree packages.
    nixpkgs.config.allowUnfree = true;

    # Enable the selected shell.
    programs.${shell}.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${username} = {
      isNormalUser = true;
      shell = pkgs.${shell};
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      dmidecode
      git
      htop
      neovim
      tmux
      unzip
      wget
      zip
    ];

    # Default fonts.
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Enable programs intercommunication bus.
    services.dbus.enable = true;

    # For storing passwords securely without a full desktop environment.
    services.gnome.gnome-keyring.enable = true;

    # Laptop.
    services.logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
      KillUserProcesses = false;
    };

    # Enable policy management for rootless programs.
    security.polkit.enable = true;

    # Nix configuration.
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 10d";
      };

      optimise.automatic = false;

      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.11"; # Did you read the comment?
  };
}
