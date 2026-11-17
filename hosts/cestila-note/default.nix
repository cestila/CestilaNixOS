{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

  services.resolved.enable = true;
}
