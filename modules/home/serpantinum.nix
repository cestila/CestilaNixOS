{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  serpantinumPkg = inputs.serpantinum.packages.${system}.default;
in {
  imports = [
    inputs.serpantinum.homeManagerModules.default
  ];

  programs.serpantinum = {
    enable = true;
    systemd.enable = false; # Managed via Hyprland exec-once
    package = serpantinumPkg;
  };
}
