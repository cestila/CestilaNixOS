{
  pkgs,
  config,
  lib,
  host,
  vars, ...
}: let
  cosmicEnable = vars.cosmicEnable or false;
in {
  config = lib.mkIf cosmicEnable {
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = false; # Keep current DM (LY or SDDM)
  };
}
