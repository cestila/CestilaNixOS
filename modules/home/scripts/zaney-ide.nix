{pkgs, ...}:
pkgs.writeShellApplication {
  name = "cestila-ide";

  runtimeInputs = with pkgs; [
    herdr
    neovim
    zsh
  ];

  text = ''
    SESSION_NAME="ide"

    echo "🚀 Starting Herdr IDE Environment..."

    exec herdr -s "$SESSION_NAME"
  '';
}
