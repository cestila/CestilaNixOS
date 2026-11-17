{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # The shell provides its own network and bluetooth indicators.
  imports = [
    ./hide-tray-applets.nix
    inputs.cestila-shell.homeManagerModules.default
  ];
}
