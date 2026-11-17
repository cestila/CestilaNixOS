{
  pkgs,
  inputs,
  lib,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  noctaliaPkg = inputs.noctalia.packages.${system}.default;
in {
  home.packages = [noctaliaPkg];

  # home.file definitions removed so Noctalia can write to settings.json,
  # plugins.json, and install/enable community plugins dynamically from its UI.

  # Disable nm-applet and blueman-applet autostart when using Noctalia
  imports = [./hide-tray-applets.nix];

  # Ensure declarative config directories exist for runtime extensions
  home.activation.ensureNoctaliaConfigDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    set -eu
    $DRY_RUN_CMD mkdir -p "$HOME/.config/noctalia/colorschemes" "$HOME/.config/noctalia/plugins"
  '';
}
