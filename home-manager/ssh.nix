{ config, lib, ... }:
{
  options.knownHosts =
    with lib;
    mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            username = mkOption {
              type = types.nonEmptyStr;
            };
            hostname = mkOption {
              type = types.nonEmptyStr;
            };
            ip = mkOption {
              type = types.nonEmptyStr;
            };
          };
        }
      );
    };

  config = {
    services.ssh-agent.enable = true;

    programs.ssh = with config; {
      enable = true;
      enableDefaultConfig = false; # default configs are deprecated.
      settings = lib.listToAttrs (
        map (host: {
          name = host.hostname;
          value = {
            hostname = host.ip;
            user = host.username;
            addKeysToAgent = "yes";
          };
        }) knownHosts
      );
    };
  };
}
