{pkgs, ...}: {
  # Google Antigravity IDE & CLI únicamente (sin escrituras de configuración en home)
  home.packages = with pkgs; [
    google-antigravity
    google-antigravity-cli
  ];
}
