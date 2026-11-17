{
  pkgs,
  config,
  ...
}: let
  ghostHome = "${config.xdg.configHome}/ghostty";
  shaderFile = "${ghostHome}/shaders/cursor_smear_gentleman.glsl";
in {
  # Disable Stylix overriding Ghostty configuration
  stylix.targets.ghostty.enable = false;

  # Declaratively symlink shaders and themes folders to the user's config directory
  xdg.configFile = {
    "ghostty/shaders" = {
      source = ./ghostty/shaders;
      recursive = true;
    };
    "ghostty/themes" = {
      source = ./ghostty/themes;
      recursive = true;
    };
  };

  # Optional background overlay configuration
  home.file."${ghostHome}/ghostty-bg.conf".text = ''
    # Overlay for background image; the wrapper passes these via CLI as well
    background-image=${config.home.homeDirectory}/Pictures/current_image_ghostty
    background-image-opacity=0.9
    background-image-position=center
    background-image-fit=cover
    background-image-repeat=false
  '';

  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    enableFishIntegration = false;
    enableZshIntegration = true;
    enableBashIntegration = true;
    clearDefaultKeybinds = true;
    settings = {
      # Font Settings
      font-family = "IosevkaTerm NF";
      font-size = 14;
      font-codepoint-map = [
        "U+E1A0-U+E1B7=Herdr Agent Icons Max"
        "U+E1C0-U+E1C5=Herdr Agent Icons Max"
      ];

      # Window Settings
      background-opacity = "0.85";
      background-blur-radius = "20";
      window-decoration = true;
      window-padding-color = "extend";
      window-step-resize = false;
      window-padding-balance = true;
      window-height = 100;
      window-width = 100;
      gtk-tabs-location = "hidden";
      window-theme = "dark";
      term = "xterm-256color";
      confirm-close-surface = "false";
      mouse-hide-while-typing = "true";
      wait-after-command = "false";
      shell-integration = "detect";
      window-save-state = "always";
      gtk-single-instance = "true";
      unfocused-split-opacity = "0.5";
      quick-terminal-position = "center";
      shell-integration-features = "cursor,sudo";
      bold-is-bright = "false";
      focus-follows-mouse = "true";
      resize-overlay = "never";

      # Shaders
      custom-shader = shaderFile;
      custom-shader-animation = "always";

      # macOS Options
      macos-option-as-alt = "left";

      # Colors (Stylix base16 harmonized)
      background = config.lib.stylix.colors.base00;
      foreground = config.lib.stylix.colors.base05;
      cursor-color = config.lib.stylix.colors.base06;
      cursor-style = "bar";
      selection-background = config.lib.stylix.colors.base02;
      selection-foreground = config.lib.stylix.colors.base05;

      palette = [
        "0=#${config.lib.stylix.colors.base00}"
        "1=#${config.lib.stylix.colors.base08}"
        "2=#${config.lib.stylix.colors.base0B}"
        "3=#${config.lib.stylix.colors.base0A}"
        "4=#${config.lib.stylix.colors.base0D}"
        "5=#${config.lib.stylix.colors.base0E}"
        "6=#${config.lib.stylix.colors.base0C}"
        "7=#${config.lib.stylix.colors.base05}"
        "8=#${config.lib.stylix.colors.base03}"
        "9=#${config.lib.stylix.colors.base08}"
        "10=#${config.lib.stylix.colors.base0B}"
        "11=#${config.lib.stylix.colors.base0A}"
        "12=#${config.lib.stylix.colors.base0D}"
        "13=#${config.lib.stylix.colors.base0E}"
        "14=#${config.lib.stylix.colors.base0C}"
        "15=#${config.lib.stylix.colors.base07}"
      ];

      # Merged Keybindings
      keybind = [
        # Copy/Paste
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"

        # Font size control
        "ctrl+shift+plus=increase_font_size:1"
        "ctrl+shift+minus=decrease_font_size:1"
        "ctrl+shift+zero=reset_font_size"

        # macOS Alt/Option keys unbinds
        "alt+left=unbind"
        "alt+right=unbind"

        # Miscellaneous
        "cmd+k=clear_screen"
        "shift+enter=text:\\x1b\\r"
        "alt+s=write_screen_file:paste"

        # Split utilities and tabs prefixed with ctrl+alt+s to avoid conflict with alt+s
        "ctrl+alt+s>r=reload_config"
        "ctrl+alt+s>x=close_surface"
        "ctrl+alt+s>n=new_window"
        "ctrl+alt+s>c=new_tab"
        "ctrl+alt+s>shift+l=next_tab"
        "ctrl+alt+s>shift+h=previous_tab"
        "ctrl+alt+s>comma=move_tab:-1"
        "ctrl+alt+s>period=move_tab:1"
        "ctrl+alt+s>1=goto_tab:1"
        "ctrl+alt+s>2=goto_tab:2"
        "ctrl+alt+s>3=goto_tab:3"
        "ctrl+alt+s>4=goto_tab:4"
        "ctrl+alt+s>5=goto_tab:5"
        "ctrl+alt+s>6=goto_tab:6"
        "ctrl+alt+s>7=goto_tab:7"
        "ctrl+alt+s>8=goto_tab:8"
        "ctrl+alt+s>9=goto_tab:9"
        "ctrl+alt+s>\\=new_split:right"
        "ctrl+alt+s>-=new_split:down"
        "ctrl+alt+s>z=toggle_split_zoom"
        "ctrl+alt+s>e=equalize_splits"
      ];
    };
  };

  # Desktop entry for ghostty-bg
  home.file."${config.xdg.dataHome}/applications/ghostty-bg.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Ghostty with Background
    Comment=Terminal emulator with random background image
    Exec=ghostty-bg --foreground
    Icon=utilities-terminal
    Terminal=false
    Categories=System;TerminalEmulator;Utility;
    Keywords=terminal;shell;prompt;
  '';

  # Wrapper script to launch Ghostty with background image from a randomized symlink
  home.packages = [
    (pkgs.writeShellScriptBin "ghostty-bg" ''
            #!/usr/bin/env bash
            set -euo pipefail

            SOURCE_DIR="$HOME/Pictures/Wallpapers"
            LINK_PATH="$HOME/Pictures/current_image_ghostty"
            LAUNCH=1
            FOREGROUND=0

            while [[ $# -gt 0 ]]; do
              case "$1" in
                -s|--source)
                  [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 2; }
                  SOURCE_DIR="$2"; shift 2;;
                -l|--link)
                  [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 2; }
                  LINK_PATH="$2"; shift 2;;
                --no-launch)
                  LAUNCH=0; shift;;
                --foreground)
                  FOREGROUND=1; shift;;
                -h|--help)
                  cat <<'EOF'
      Usage: ghostty-bg [options] [--] [ghostty_args...]

      Defaults: Launches ghostty in the background with background-image linked at ~/Pictures/current_image_ghostty

      Options:
        -s, --source DIR   Source directory of images (default: ~/Pictures/Wallpapers)
        -l, --link PATH    Symlink path (default: ~/Pictures/current_image_ghostty)
            --no-launch    Only update symlink; do not launch ghostty
            --foreground   Run ghostty in the foreground (default is background)
        -h, --help         Show this help
      EOF
                  exit 0;;
                --)
                  shift; break;;
                -*)
                  echo "Unknown option: $1" >&2; exit 2;;
                *)
                  break;;
              esac
            done

            if [[ ! -d "$SOURCE_DIR" ]]; then
              echo "Source directory not found: $SOURCE_DIR" >&2
              exit 1
            fi

            CHOSEN="$(${pkgs.findutils}/bin/find -L "$SOURCE_DIR" -type f \
              \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.bmp' -o -iname '*.gif' \) \
              -print0 | ${pkgs.coreutils}/bin/shuf -z -n 1 | ${pkgs.coreutils}/bin/tr -d '\0')"
            if [[ -z "$CHOSEN" ]]; then
              echo "No images found in: $SOURCE_DIR" >&2
              exit 1
            fi

            mkdir -p "$(dirname "$LINK_PATH")"
            ln -sfn "$CHOSEN" "$LINK_PATH"

            if (( LAUNCH )); then
              if (( FOREGROUND )); then
                exec ghostty \
                  --background-image="$LINK_PATH" \
                  --background-image-opacity=0.9 \
                  --background-image-position=center \
                  --background-image-fit=cover \
                  --background-image-repeat=false \
                  "$@"
              else
                setsid -f ghostty \
                  --background-image="$LINK_PATH" \
                  --background-image-opacity=0.9 \
                  --background-image-position=center \
                  --background-image-fit=cover \
                  --background-image-repeat=false \
                  "$@" >/dev/null 2>&1 < /dev/null &
              fi
            fi
    '')
  ];
}
