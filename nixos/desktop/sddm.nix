{
  config,
  lib,
  ...
}:
{
  options.displayManager.sddm = with lib; {
    enable = mkEnableOption "sddm";
  };

  config =
    with config.displayManager;
    lib.mkIf sddm.enable {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
}
