{profile, ...}: {
  # Services to start
  services = {
    upower.enable = true; # noctalia shell battery
    libinput.enable = true; # Input Handling
    fstrim.enable = true; # SSD Optimizer
    gvfs.enable = true; # For Mounting USB & More
    envfs = {
      enable = true; # Fuse filesystem for /bin and /usr/bin shebang compatibility
      extraFallbackPathCommands = ''
        ln -s /run/current-system/sw/bin/setpriv $out/setpriv
      '';
    };
    power-profiles-daemon.enable = true;
    openssh = {
      enable = true; # Enable SSH
      settings = {
        PermitRootLogin = "no"; # Prevent root from SSH login
        PasswordAuthentication = false; # Users must SSH using public key authentication
        KbdInteractiveAuthentication = false;
      };
      ports = [22];
    };
    blueman.enable = true; # Bluetooth Support
    gnome.gnome-keyring.enable = true;

    smartd = {
      enable =
        if profile == "vm"
        then false
        else true;
      autodetect = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 256;
          "default.clock.max-quantum" = 256;
          "module.x11.bell" = false;
        };
      };
      extraConfig.pipewire-pulse."92-low-latency" = {
        context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "256/48000";
              pulse.default.req = "256/48000";
              pulse.max.req = "256/48000";
              pulse.min.quantum = "256/48000";
              pulse.max.quantum = "256/48000";
            };
          }
        ];
      };
    };
    ollama = {
      enable = false; # On-demand: run manually when needed via 'ollama serve'
    };

    logind = {
      settings = {
        Login = {
          HandleLidSwitch = "ignore";
          HandleLidSwitchExternalPower = "ignore";
          HandleLidSwitchDocked = "ignore";
          IdleAction = "ignore";
        };
      };
    };
  };
}
