# Hide the NetworkManager and Blueman tray applets from XDG autostart.
# Shells with their own network/bluetooth indicators (noctalia, cestila-shell)
# import this so systemd's xdg-autostart generator does not spawn the applets.
# The underlying NetworkManager and Blueman services stay enabled.
{...}: {
  xdg.configFile."autostart/nm-applet.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Network Manager Applet
    Hidden=true
  '';
  xdg.configFile."autostart/blueman.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Blueman Applet
    Hidden=true
  '';
}
