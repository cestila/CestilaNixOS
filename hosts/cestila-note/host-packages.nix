{
  configs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    #  Add local pacakaged here
    dnsutils
  ];
  # Add host specific flatpaks here
  services = {
    flatpak = {
      packages = [
        "org.onlyoffice.desktopeditors"
      ];
    };
  };

  services.auto-cpufreq.enable = false;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };
}
