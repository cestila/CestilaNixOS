{
  pkgs,
  host,
  ...
}: let
  vars = import ../../hosts/${host}/variables.nix;
  hyprlandEnable = vars.hyprlandEnable or true;
in {
  xdg.portal = {
    enable = true;
    extraPortals =
      if hyprlandEnable
      then []
      else [pkgs.xdg-desktop-portal-gtk];
    configPackages =
      if hyprlandEnable
      then []
      else [];
  };
  services = {
    flatpak = {
      enable = true;

      # List the Flatpak applications you want to install
      # Use the official Flatpak application ID (e.g., from flathub.org)
      # Examples:
      packages = [
        #"com.github.tchx84.Flatseal" #Manage flatpak permissions - should always have this
        #"com.rtosta.zapzap" # WhatsApp client
        #"io.github.flattool.Warehouse"   # Manage flatpaks, clean data, remove flatpaks and deps
        #"it.mijorus.gearlever" # Manage and support AppImages
        #"io.github.freedoom.Phase1"      #  Classic Doom FPS 1
        #"io.github.freedoom.Phase2"      #  Classic Doom FPS 2
        #"io.github.dvlv.boxbuddyrs"      #  Manage distroboxes
        #"de.schmidhuberj.tubefeeder"     #watch YT videos

        # Add other Flatpak IDs here, e.g., "org.mozilla.firefox"
        "com.rtosta.zapzap"
        "org.telegram.desktop"
        "app.freelens.Freelens"
      ];

      # Optional: Automatically update Flatpaks when you run nixos-rebuild switch
      update.onActivation = true;

      overrides = {
        global = {
          Context = {
            filesystems = [
              "/nix/store:ro"
              "xdg-config/gtk-3.0:ro"
              "xdg-config/gtk-4.0:ro"
              "~/.themes:ro"
              "~/.icons:ro"
              "/run/current-system/sw/share/themes:ro"
              "/run/current-system/sw/share/icons:ro"
            ];
          };
          Environment = {
            TZ = "America/Argentina/Buenos_Aires";
            GTK_THEME = "adw-gtk3:dark";
            GTK_APPLICATION_PREFER_DARK_THEME = "1";
          };
        };
        "org.telegram.desktop" = {
          Context = {
            filesystems = [
              "home"
            ];
          };
        };
      };
    };
  };
}
