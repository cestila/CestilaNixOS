{
  pkgs,
  host,
  options,
  vars, ...
}: let
  inherit (vars) hostId;
in {
  networking = {
    hostName = "${host}";
    hostId = hostId;
    networkmanager = {
      enable = true;
      wifi.powersave = false;
      plugins = with pkgs; [
        networkmanager-l2tp
        networkmanager-openconnect
        networkmanager-openvpn
      ];
    };
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
        59010
        59011
        8080
      ];
      allowedUDPPorts = [
        51820
        59010
        59011
      ];
    };
  };

  services.strongswan = {
    enable = true;
    secrets = ["ipsec.d/ipsec.nm-l2tp.secrets"];
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    wireguard-tools
    openconnect
    openfortivpn
  ];
}
