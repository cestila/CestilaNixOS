{
  pkgs,
  host,
  vars, ...
}: let
  consoleKeyMap = vars.consoleKeyMap or "es";
  defaultLocale = vars.defaultLocale or "es_AR.UTF-8";
  timeZone = vars.timeZone or "America/Argentina/Buenos_Aires";
in {
  nix = {
    settings = {
      download-buffer-size = 200000000;
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };
  time.timeZone = timeZone;
  i18n.defaultLocale = defaultLocale;
  i18n.supportedLocales = [
    "es_AR.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];
  i18n.extraLocaleSettings = {
    LC_ADDRESS = defaultLocale;
    LC_IDENTIFICATION = defaultLocale;
    LC_MEASUREMENT = defaultLocale;
    LC_MONETARY = defaultLocale;
    LC_NAME = defaultLocale;
    LC_NUMERIC = defaultLocale;
    LC_PAPER = defaultLocale;
    LC_TELEPHONE = defaultLocale;
    LC_TIME = defaultLocale;
  };
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    CESTILANIXOS_VERSION = "2.6.2";
    CESTILANIXOS = "true";
    LANG = defaultLocale;
    LC_ALL = defaultLocale;
  };
  console.keyMap = "${consoleKeyMap}";
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      fuse3
      icu
      nss
      openssl
      curl
      expat

      # Soporte gráfico, Wayland, X11, Vulkan y fuentes para binarios FHS externos (e.g. herdr-app)
      libxcb
      libxkbcommon
      wayland
      libGL
      vulkan-loader
      fontconfig
      freetype
      libx11
      libxcursor
      libxrandr
      libxi
      libxext
      libxfixes
      libxrender
    ];
  };

  # FHS compatibility symlinks for installers hardcoding standard paths (e.g. gentle-pi)
  systemd.tmpfiles.rules = [
    "L+ /usr/bin/tar - - - - ${pkgs.gnutar}/bin/tar"
    "L+ /bin/tar - - - - ${pkgs.gnutar}/bin/tar"
  ];

  system.stateVersion = "23.11"; # Do not change!
}
