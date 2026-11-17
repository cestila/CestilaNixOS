{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "Carlos Estilarte";
  gitEmail = "cestila@gmail.com";

  # Set Timezone & Locale
  timeZone = "America/Argentina/Buenos_Aires";
  defaultLocale = "es_AR.UTF-8";

  # Set Flake Path
  flakePath = "/home/cestila/workspace/Personales/CestilaNixOS";

  # Set Displau Manager
  # `tui` for Text login
  # `sddm` for graphical GUI (default)
  # SDDM background is set with stylixImage
  displayManager = "tui";

  # Enable/disable bundled applications and desktop environments
  cosmicEnable = false;
  hyprlandEnable = true; # Toggle Hyprland compositor, Noctalia/Waybar, Rofi, etc.
  homestudioEnable = true; # Home Studio & Audio Production (REAPER, synths, plugins, low-latency)
  homestudioWindowsVstEnable = false; # Soporte para plugins VST de Windows (Wine Staging, Yabridge, DXVK, Vulkan)

  # Perfiles de Desarrollo (TUI / GUI)
  devTuiEnable = true; # Modo Terminal: Herdr, Neovim/LazyVim, Engram, Antigravity-CLI, Pomodoro, Node/Python/uv/Podman
  devGuiEnable = false; # Modo Gráfico: Orca ADE, Antigravity IDE, VSCode, Zed Editor, Engram, Node/Python/uv/Podman

  # Perfiles DevOps, Cloud & Administración de Sistemas (TUI / GUI)
  devopsTuiEnable = true; # Modo Terminal: k9s, kubectl, helm, terraform, ansible, vault, harlequin, usql, pgcli, mycli, cloud CLIs
  devopsGuiEnable = true; # Modo Gráfico: DBeaver, Bruno (API client), Remmina (RDP/SSH/VNC), Freelens (Flatpak)

  # Herramientas de Comunicación / Mensajería
  conduitEnable = true; # ConduitOmniChat: Cliente Electron + daemon conduitd multi-red

  # Opciones individuales de editores/terminales
  tmuxEnable = false;
  alacrittyEnable = false;
  weztermEnable = false;
  ghosttyEnable = true;
  vscodeEnable = false;
  antigravityEnable = false;
  zedEnable = false;
  # Note: This is evil-helix with VIM keybindings by default
  helixEnable = false;
  #To install: Enable here, cnixcli rebuild, then run cnixcli doom install
  doomEmacsEnable = false;

  # Python development tools are included by default

  # Hyprland Settings
  # Examples:
  #extraMonitorSettings = "monitor = eDP-1,1920x1080@60,auto,1";
  #extraMonitorSettings = "monitor = HDMI-A-1,1920x1080@60,auto,1";
  # You can configure multiple monitors.
  # Inside the quotes, create a new line for each monitor.
  extraMonitorSettings = "
    monitor = eDP-1,1920x1080@60,auto,1
    monitor = HDMI-A-1,1920x1080@60,auto,1
  ";

  # Bar/Shell Settings
  # Choose between dux-shell, serpantinum, cestila-shell, ryoku, noctalia, or waybar
  barChoice = "dux-shell";

  # Waybar Settings (used when barChoice = "waybar")
  clock24h = true;

  # Program Options
  # Set Default Browser (google-chrome-stable for google-chrome)
  # This does NOT install your browser
  # You need to install it by adding it to the `packages.nix`
  # or as a flatpak
  browser = "google-chrome-stable";

  # Host-level default applications (picked up by Home Manager xdg.mimeApps)
  # Uncomment and adjust the .desktop IDs to set per-host defaults.
  mimeDefaultApps = {
    # PDFs
    "application/pdf" = ["okular.desktop"];
    "application/x-pdf" = ["okular.desktop"];
    # Web browser
    "x-scheme-handler/http" = ["google-chrome.desktop"]; # or brave-browser.desktop, firefox.desktop
    "x-scheme-handler/https" = ["google-chrome.desktop"];
    "text/html" = ["google-chrome.desktop"];
    # Files
    "inode/directory" = ["pcmanfm.desktop"]; # file manager
    "text/plain" = ["code.desktop"]; # or code.desktop

    # OnlyOffice documents
    "application/msword" = ["org.onlyoffice.desktopeditors.desktop"];
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["org.onlyoffice.desktopeditors.desktop"];
    "application/vnd.ms-word.document.macroEnabled.12" = ["org.onlyoffice.desktopeditors.desktop"];
    "application/vnd.ms-excel" = ["org.onlyoffice.desktopeditors.desktop"];
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = ["org.onlyoffice.desktopeditors.desktop"];
    "application/vnd.ms-excel.sheet.macroEnabled.12" = ["org.onlyoffice.desktopeditors.desktop"];
    "application/vnd.ms-powerpoint" = ["org.onlyoffice.desktopeditors.desktop"];
    "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["org.onlyoffice.desktopeditors.desktop"];
    "application/vnd.ms-powerpoint.presentation.macroEnabled.12" = ["org.onlyoffice.desktopeditors.desktop"];
    "application/vnd.oasis.opendocument.text" = ["org.onlyoffice.desktopeditors.desktop"];
    "application/vnd.oasis.opendocument.spreadsheet" = ["org.onlyoffice.desktopeditors.desktop"];
    "application/vnd.oasis.opendocument.presentation" = ["org.onlyoffice.desktopeditors.desktop"];
  };

  # Available Options:
  # Kitty, ghostty, wezterm, aalacrity
  # Note: kitty, wezterm, alacritty have to be enabled in `variables.nix`
  # Setting it here does not enable it. Kitty is installed by default
  terminal = "ghostty"; # Set Default System Terminal

  keyboardLayout = "es";
  keyboardVariant = "";
  consoleKeyMap = "es";

  # For hybrid support (Intel/NVIDIA Prime or AMD/NVIDIA)
  intelID = "PCI:1:0:0";
  amdgpuID = "PCI:5:0:0";
  nvidiaID = "PCI:0:2:0";

  # Enable NFS
  enableNFS = true;

  # Enable Printing Support
  printEnable = true;

  # Enable PCManFM GUI File Manager
  # Yazi is alternate File Manager
  pcmanfmEnable = true;

  # Themes, waybar and animation.
  #  Only uncomment your selection
  # The others much be commented out.

  # Set Stylix Image
  # This will set your color palette
  # Default background
  # Add new images to ~/CestilaNixOS/wallpapers
  #stylixImage = ../../wallpapers/Rainnight.jpg;
  #stylixImage = ../../wallpapers/Anime-Purple-eyes.png;
  #stylixImage = ../../wallpapers/AnimeGirlNightSky.jpg;
  stylixImage = ../../wallpapers/cestilanixos-cyber-grid.png;

  # Set Waybar
  #  Available Options:
  #waybarChoice = ../../modules/home/waybar/waybar-curved.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-ddubs.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-ddubs-2.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-simple.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-dwm.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-dwm-2.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-nekodyke.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-jerry.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-TheBlackDon.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-tony.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-ddubsos-v1.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-mecha.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-jak-catppuccin.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-jak-ml4w-modern.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-jak-oglo-simple.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-jwt-catppuccin.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-jwt-transparent.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-jwt-ultradark.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-pctrade-catppuccin.nix;
  waybarChoice = ../../modules/home/waybar/waybar-mangowc-jak-catppuccin.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-old-ddubsos.nix;

  # Set Animation style
  # Available options are:
  #animChoice = ../../modules/home/hyprland/animations-def.nix;
  #animChoice = ../../modules/home/hyprland/animations-end4.nix;
  #animChoice = ../../modules/home/hyprland/animations-end4-slide.nix;
  #animChoice = ../../modules/home/hyprland/animations-end-slide.nix;
  #animChoice = ../../modules/home/hyprland/animations-dynamic.nix;
  #animChoice = ../../modules/home/hyprland/animations-moving.nix;
  #animChoice = ../../modules/home/hyprland/animations-hyde-optimized.nix;
  #animChoice = ../../modules/home/hyprland/animations-mahaveer-me-1.nix;
  #animChoice = ../../modules/home/hyprland/animations-mahaveer-me-2.nix;
  animChoice = ../../modules/home/hyprland/animations-ml4w-classic.nix;
  #animChoice = ../../modules/home/hyprland/animations-ml4w-fast.nix;
  #animChoice = ../../modules/home/hyprland/animations-ml4w-high.nix;

  # Set network hostId if required (needed for zfs)
  # Otherwise leave as-is
  hostId = "5ab03f50";
}
