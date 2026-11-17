{
  host,
  pkgs,
  vars, ...
}: let
  inherit (vars) printEnable;
in {
  services = {
    printing = {
      enable = printEnable;
      drivers = [
        pkgs.brlaser
        pkgs.cnijfilter2
        pkgs.cups-bjnp
        pkgs.gutenprint
      ];
    };
    avahi = {
      enable = printEnable;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = printEnable;
  };
}
