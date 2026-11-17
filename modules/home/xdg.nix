{
  pkgs,
  host,
  lib,
  vars, ...
}: {
  xdg = {
    enable = true;
    mime.enable = true;
    configFile."containers/policy.json".text = ''
      {
        "default": [
          {
            "type": "insecureAcceptAnything"
          }
        ],
        "transports": {
          "docker-daemon": {
            "": [
              {
                "type": "insecureAcceptAnything"
              }
            ]
          }
        }
      }
    '';
    mimeApps = {
      enable = true;
      # If the host defines mimeDefaultApps in hosts/${host}/variables.nix,
      # use it to set per-host default applications.
      defaultApplications = lib.mkIf (vars ? mimeDefaultApps) vars.mimeDefaultApps;

      # Example: set default handlers for MIME types and URL schemes.
      # Uncomment the block below and adjust .desktop IDs to your preferred apps.
      # defaultApplications = {
      #   # PDFs
      #   "application/pdf" = ["okular.desktop"];      # change to your preferred reader
      #   "application/x-pdf" = ["okular.desktop"];    # legacy alias
      #
      #   # Web browser
      #   "x-scheme-handler/http"  = ["google-chrome.desktop"];  # or brave-browser.desktop, firefox.desktop, etc.
      #   "x-scheme-handler/https" = ["google-chrome.desktop"];
      #   "text/html"              = ["google-chrome.desktop"];
      #
      #   # Text files
      #   "text/plain" = ["nvim.desktop"];             # or code.desktop, org.gnome.TextEditor.desktop
      #
      #   # Images and video
      #   "image/png" = ["imv.desktop"];               # or org.gnome.eog.desktop
      #   "video/mp4" = ["mpv.desktop"];               # or vlc.desktop
      #
      #   # Archives
      #   "application/zip" = ["org.gnome.FileRoller.desktop"]; # or xarchiver.desktop, peazip.desktop
      #
      #   # Folders (file manager)
      #   "inode/directory" = ["thunar.desktop"];      # or org.gnome.Nautilus.desktop, org.kde.dolphin.desktop
      # };
    };
    # portal is managed at system level by programs.hyprland and nixos xdg.portal
    # portal = {
    #   enable = true;
    #   extraPortals = [pkgs.xdg-desktop-portal-hyprland];
    #   configPackages = [pkgs.hyprland];
    # };
  };
}
