{
  host,
  pkgs,
  lib,
  vars, ...
}: let
  inherit (vars) pcmanfmEnable;
in {
  environment.systemPackages = lib.optionals pcmanfmEnable (with pkgs; [
    pcmanfm
    ffmpegthumbnailer # Video / Image Preview
  ]);
}
