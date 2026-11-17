{
  pkgs,
  username,
  host,
  vars, ...
}: {
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
