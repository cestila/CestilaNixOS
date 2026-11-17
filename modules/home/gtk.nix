{
  pkgs,
  lib,
  ...
}: {
  gtk = {
    gtk4.theme = lib.mkForce null;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-error-bell = 0;
      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-error-bell = 0;
      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;
    };
  };
}
