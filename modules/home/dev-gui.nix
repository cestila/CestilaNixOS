{pkgs, ...}: {
  imports = [
    ./dev-base.nix
    ./editors/antigravity.nix
    ./editors/vscode.nix
    ./editors/zed.nix
  ];

  home.packages = with pkgs; [
    # Herramientas GUI adicionales recomendadas
    pomodoro-gtk
    # orca-ide # Orca ADE - Entorno para orquestar agentes IA en paralelo (onorca.dev)
  ];
}
