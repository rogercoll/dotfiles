{
  name,
  lib,
  osConfig,
  ...
}:
{
  programs.home-manager.enable = true;

  home.username = name;
  home.homeDirectory = "/home/${name}";

  home.sessionVariables = lib.mkMerge [
    (lib.mkIf (osConfig.virtualisation.podman.enable) {
      DOCKER_HOST = "unix:///run/user/\${UID}/podman/podman.sock";
    })
    { }
  ];

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "25.11";
}
