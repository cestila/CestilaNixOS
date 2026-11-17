{pkgs, ...}: {
  # Solo instalamos el binario, NO habilitamos programs.git.enable
  # para evitar que Home Manager gestione la configuración (~/.gitconfig)
  home.packages = [pkgs.git];
}
