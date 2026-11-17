{
  pkgs,
  config,
  lib,
  host,
  ...
}: let
  vars = import ../../hosts/${host}/variables.nix;
  cosmicEnable = vars.cosmicEnable or false;
in {
  config = lib.mkIf cosmicEnable {
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = false; # Keep current DM (LY or SDDM)
  };
}
