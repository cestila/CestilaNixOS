{pkgs, ...}: {
  # Install official VS Code package without declarative settings or extensions,
  # allowing native extension installation and GitHub Settings Sync.
  home.packages = [
    pkgs.vscode
  ];
}
