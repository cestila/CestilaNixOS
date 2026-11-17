{
  inputs,
  pkgs,
  host,
  ...
}: let
  vars = import ../../hosts/${host}/variables.nix;
  inherit (vars) barChoice;
  hyprlandEnable = vars.hyprlandEnable or true;

  # Noctalia-specific packages (only if hyprland is enabled)
  noctaliaPkgs =
    if hyprlandEnable && (barChoice == "noctalia")
    then
      with pkgs; [
        matugen # color palette generator needed for noctalia-shell
        app2unit # launcher for noctalia-shell
        gpu-screen-recorder # needed for noctalia-shell
      ]
    else [];

  # Hyprland-specific packages
  hyprlandPkgs =
    if hyprlandEnable
    then
      with pkgs; [
        cliphist # Clipboard manager using rofi menu
        nwg-displays # configure monitor configs via GUI
        nwg-drawer # Application launcher for wayland
        nwg-dock-hyprland # Dock for hyprland
        nwg-menu # App menu for waybar
        waypaper # Change wallpaper
      ]
    else [];

in {
  programs = {
    firefox.enable = false; # Firefox is not installed by default
    hyprland = {
      enable = hyprlandEnable; # set this so desktop file is created
    };
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    hyprlock.enable = hyprlandEnable;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  environment.variables.EDITOR = "nano";
  environment.variables.VISUAL = "nano";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = ["openssl-1.1.1w"];

  environment.systemPackages = with pkgs;
    [
      awww
      inputs.synfetch.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]
    ++ noctaliaPkgs
    ++ hyprlandPkgs
    ++ [
      alejandra # nix formatter
      appimage-run # Needed For AppImage Support
      # brave # Brave Browser
      brightnessctl # For Screen Brightness Control
      discord # All-in-one voice and text chat
      podman-compose # Allows Controlling Podman From A Single File
      duf # Utility For Viewing Disk Usage In Terminal
      dysk # Disk space util nice formattting
      eza # Beautiful ls Replacement
      ffmpeg # Terminal Video / Audio Editing
      file-roller # Archive Manager
      fd # find util needed for emacs but good util regardless vs. find
      google-chrome # Web Browser
      gnumake # Needed for emacs
      gpu-screen-recorder # needed for noctalia-shell
      power-profiles-daemon # needed for noctalia-shell power cycle
      mesa-demos # needed for inxi diag util
      tuigreet # The Login Manager (Sometimes Referred To As Display Manager)
      htop # Simple Terminal Based System Monitor
      eog # For Image Viewing
      inxi # CLI System Information Tool
      killall # For Killing All Instances Of Programs
      libnotify # For Notifications
      lm_sensors # Used For Getting Hardware Temps
      lshw # Detailed Hardware Information
      mdcat # CLI markdown parser
      mpv # Incredible Video Player
      ncdu # Disk Usage Analyzer With Ncurses Interface
      nixfmt # Nix Formatter
      notion-app-enhanced # Notion desktop application (notion-enhancer)
      onefetch # provides build info on current system
      ollama # Local LLM runner (run on-demand via 'ollama serve')
      pandoc # format MD to HTML for cheatsheet parser
      pavucontrol # For Editing Audio Levels & Devices
      pciutils # Collection Of Tools For Inspecting PCI Devices
      pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
      playerctl # Allows Changing Media Volume Through Scripts
      ripgrep # Improved Grep
      sqlite # needed for emacs
      socat # Needed For Screenshots
      unrar # Tool For Handling .rar Files
      unzip # Tool For Handling .zip Files
      usbutils # Good Tools For USB Devices
      upower # noctalia shell battery
      uwsm # Universal Wayland Session Manager (optional must be enabled)
      v4l-utils # Used For Things Like OBS Virtual Camera
      wget # Tool For Fetching Files With Links
      wkhtmltopdf # Tool to render HTML into PDF and various image formats
      wl-clipboard # Wayland clipboard utilities (wl-copy/wl-paste)
      python3 # Python 3 programming language
      ghidra # Software reverse engineering suite (used by REA MCP)
      gdb # GNU Debugger
    ];
}
