{
  pkgs,
  username,
  host,
  ...
}: let
  vars = import ../../hosts/${host}/variables.nix;
in {
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };
    flake = vars.flakePath or "/home/${username}/CestilaNixOS";
  };

  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nvd
  ];
}
