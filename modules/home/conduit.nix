{
  pkgs,
  inputs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  conduitPkg = inputs.conduit.packages.${system}.default;
  conduitdPkg = inputs.conduit.packages.${system}.conduitd;
in {
  home.packages = [
    conduitPkg
    conduitdPkg
  ];
}
