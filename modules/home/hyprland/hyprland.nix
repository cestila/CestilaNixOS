{
  host,
  config,
  pkgs,
  lib,
  ...
}: let
  vars = import ../../../hosts/${host}/variables.nix;
  extraMonitorSettings = vars.extraMonitorSettings or "";
  keyboardLayout = vars.keyboardLayout or "us";
  keyboardVariant = vars.keyboardVariant or "";
  stylixImage = vars.stylixImage or null;
  barChoice = vars.barChoice or "";
  isCestila = barChoice == "cestila-shell" || barChoice == "cestila";

  # Treat only known US-based variants as implying layout = "us".
  usVariants = ["dvorak" "colemak" "workman" "intl" "us-intl" "altgr-intl"];
  normalizeUSVariant = v:
    if v == "us-intl"
    then "intl"
    else v;

  layoutFromLayout =
    if builtins.elem keyboardLayout usVariants
    then "us"
    else keyboardLayout;
  variantFromLayout =
    if builtins.elem keyboardLayout usVariants
    then normalizeUSVariant keyboardLayout
    else "";

  layoutFromVariant =
    if builtins.elem keyboardVariant usVariants
    then "us"
    else layoutFromLayout;
  variantFinal =
    if builtins.elem keyboardVariant usVariants
    then normalizeUSVariant keyboardVariant
    else if variantFromLayout != ""
    then variantFromLayout
    else keyboardVariant;

  hyprKbLayout = layoutFromVariant;
  hyprKbVariant = variantFinal;
in {
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    swappy
    ydotool
    hyprpolkitagent
    hyprshot
    hyprshutdown
    hyprpicker
  ];

  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "Hyprland session";
      Documentation = ["man:systemd.special(7)"];
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target" "xdg-desktop-autostart.target"];
      After = ["graphical-session-pre.target"];
    };
  };

  home.file = {
    "Pictures/Wallpapers" = {
      source = ../../../wallpapers;
      recursive = true;
    };
    ".face.icon".source = ./face.jpg;
    ".config/face.jpg".source = ./face.jpg;
  };

  # Disable legacy hyprlang Home Manager module (v0.57.0 dropped hyprland.conf)
  wayland.windowManager.hyprland.enable = false;

  # Hyprland Lua Configuration (Hyprland v0.57.0+)
  xdg.configFile."hypr/hyprland.lua".text = ''
    -- Hyprland Lua Configuration (Hyprland v0.57.0+)
    -- Managed by NixOS / Home Manager

    require("lua.env")
    require("lua.monitors")
    require("lua.input")
    require("lua.looknfeel")
    require("lua.animations")
    require("lua.rules")
    require("lua.binds")
    require("lua.autostart")
  '';

  xdg.configFile."hypr/lua/input.lua".text = ''
    -- Input & Gestures Configuration
    hl.config({
        input = {
            kb_layout = "${hyprKbLayout}",
            kb_variant = "${hyprKbVariant}",
            kb_options = "grp:alt_caps_toggle,caps:super",
            numlock_by_default = true,
            repeat_delay = 300,
            repeat_rate = 50,
            follow_mouse = 1,
            float_switch_override_focus = 0,
            sensitivity = 0,
            touchpad = {
                natural_scroll = true,
                disable_while_typing = true,
                scroll_factor = 0.8,
            },
        },
        gestures = {
            workspace_swipe_distance = 500,
            workspace_swipe_invert = true,
            workspace_swipe_min_speed_to_force = 30,
            workspace_swipe_cancel_ratio = 0.5,
            workspace_swipe_create_new = true,
            workspace_swipe_forever = true,
        },
    })

    hl.gesture({
        fingers = 3,
        direction = "horizontal",
        action = "workspace",
    })
  '';

  xdg.configFile."hypr/lua/monitors.lua".text = ''
    -- Monitors Configuration
    hl.monitor({
        output = "",
        mode = "preferred",
        position = "auto",
        scale = "auto",
    })

    hl.monitor({
        output = "eDP-1",
        mode = "1920x1080@60",
        position = "auto",
        scale = 1,
    })

    hl.monitor({
        output = "HDMI-A-1",
        mode = "1920x1080@60",
        position = "auto",
        scale = 1,
    })

    hl.monitor({
        output = "Virtual-1",
        mode = "1920x1080@60",
        position = "auto",
        scale = 1,
    })
  '';

  xdg.configFile."hypr/lua/looknfeel.lua".text = ''
    -- Look and Feel Configuration
    hl.config({
        general = {
            layout = "dwindle",
            gaps_in = 6,
            gaps_out = 8,
            border_size = 2,
            resize_on_border = true,
            allow_tearing = false,
            col = {
                active_border = {
                    colors = {
                        ${if isCestila then ''"rgb(a855f7)", "rgb(581c87)"'' else ''"rgb(${config.lib.stylix.colors.base08})", "rgb(${config.lib.stylix.colors.base0C})"''},
                    },
                    angle = 45,
                },
                inactive_border = ${if isCestila then ''"rgb(1c1c27)"'' else ''"rgb(${config.lib.stylix.colors.base01})"''},
            },
        },

        decoration = {
            rounding = 10,
            rounding_power = 2,
            active_opacity = 1.0,
            inactive_opacity = 1.0,
            blur = {
                enabled = true,
                size = 5,
                passes = 3,
                ignore_opacity = false,
                new_optimizations = true,
            },
            shadow = {
                enabled = true,
                range = 4,
                render_power = 3,
                color = 0xee1a1a1a,
            },
        },

        dwindle = {
            preserve_split = true,
            smart_resizing = true,
            use_active_for_splits = true,
            smart_split = false,
            default_split_ratio = 1.0,
            split_bias = 0,
            special_scale_factor = 0.8,
        },

        master = {
            new_status = "slave",
            new_on_top = false,
            new_on_active = "none",
            orientation = "left",
            mfact = 0.55,
            slave_count_for_center_master = 2,
            center_master_fallback = "left",
            smart_resizing = true,
            drop_at_cursor = true,
            always_keep_position = false,
        },

        scrolling = {
            column_width = 0.80,
            fullscreen_on_one_column = true,
            direction = "right",
            follow_focus = true,
        },

        misc = {
            layers_hog_keyboard_focus = true,
            initial_workspace_tracking = 0,
            mouse_move_enables_dpms = true,
            key_press_enables_dpms = true,
            disable_hyprland_logo = true,
            disable_splash_rendering = true,
            enable_swallow = false,
            vrr = 0,
            focus_on_activate = false,
            enable_anr_dialog = true,
            anr_missed_pings = 15,
        },

        cursor = {
            sync_gsettings_theme = true,
            no_hardware_cursors = 2,
            enable_hyprcursor = false,
            warp_on_change_workspace = 2,
            no_warps = true,
        },

        render = {
            direct_scanout = 0,
        },

        ecosystem = {
            no_donation_nag = true,
            no_update_news = false,
        },

        xwayland = {
            force_zero_scaling = true,
        },
    })
  '';
}
