{ config, ... }:
{
  virtualisation.docker.enable = true;

  users.users.${config.profile.username}.extraGroups = [ "docker" ];
}
