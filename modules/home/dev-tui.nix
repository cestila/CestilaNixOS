{
  pkgs,
  host,
  lib,
  vars, ...
}: let
  hyprlandEnable = vars.hyprlandEnable or true;
in {
  imports =
    [
      ./dev-base.nix
      ./herdr.nix
      ./editors/neovim.nix
    ]
    ++ (
      if hyprlandEnable
      then [./terminals/ghostty.nix]
      else []
    );

  home.packages = with pkgs; [
    # Google Antigravity CLI para terminal
    google-antigravity-cli

    # Pomodoro para escritorio (COSMIC / Wayland)
    pomodoro-gtk

    # Visores TUI de Markdown y soporte de diagramas
    glow
    mdcat
    mermaid-cli
  ];

  # Configurar Neovim como editor por defecto en sesión
  home.sessionVariables = {
    EDITOR = lib.mkDefault "nvim";
    VISUAL = lib.mkDefault "nvim";
  };
}
