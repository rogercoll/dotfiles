{
  config,
  lib,
  ...
}:
{
  options.profile = with lib; {
    hostname = mkOption {
      type = types.nonEmptyStr;
    };
  };


  config = with config.profile; {
    networking.networkmanager.enable = true;
    networking.hostName = hostname; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # most complete service that provides network name resolution to local applications via a D-Bus
    services.resolved.enable = true;

    # Enable tailscale service
    services.tailscale = {
      # Enable tailscale at startup
      enable = true;

      # See: https://github.com/tailscale/tailscale/issues/4254
      extraSetFlags = [ "--accept-dns=false" ];
    };
  };
}
