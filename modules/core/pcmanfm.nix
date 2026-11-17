{
  host,
  pkgs,
  lib,
  ...
}: let
  inherit (import ../../hosts/${host}/variables.nix) pcmanfmEnable;
in {
  environment.systemPackages = lib.optionals pcmanfmEnable (with pkgs; [
    pcmanfm
    ffmpegthumbnailer # Video / Image Preview
  ]);
}
