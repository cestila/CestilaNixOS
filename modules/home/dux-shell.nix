{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # Hide tray applets handled by the shell (network, bluetooth, etc.)
  imports = [
    ./hide-tray-applets.nix
    inputs.dux-shell.homeModules.dank-material-shell
  ];

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
  };

  # Disable Stylix's auto-generated read-only store symlinks for settings.json and session.json
  # so Dux Shell can persist wallpapers, themes, and GUI settings changes without permission errors.
  stylix.targets.dank-material-shell.enable = false;

  # Ensure settings.json and session.json remain mutable files for GUI persistence
  home.activation.setupDuxPersistence = lib.hm.dag.entryAfter ["writeBoundary"] ''
    SETTINGS_FILE="$HOME/.config/dms/settings.json"
    mkdir -p "$HOME/.config/dms"
    if [ -L "$SETTINGS_FILE" ]; then
      SRC=$(readlink -f "$SETTINGS_FILE")
      rm -f "$SETTINGS_FILE"
      if [ -f "$SRC" ]; then
        cp "$SRC" "$SETTINGS_FILE"
      else
        echo "{}" > "$SETTINGS_FILE"
      fi
      chmod 644 "$SETTINGS_FILE"
    fi

    SESSION_FILE="$HOME/.local/state/dms/session.json"
    mkdir -p "$HOME/.local/state/dms"
    if [ -L "$SESSION_FILE" ]; then
      SRC=$(readlink -f "$SESSION_FILE")
      rm -f "$SESSION_FILE"
      if [ -f "$SRC" ]; then
        cp "$SRC" "$SESSION_FILE"
      else
        echo "{}" > "$SESSION_FILE"
      fi
      chmod 644 "$SESSION_FILE"
    fi
  '';
}
