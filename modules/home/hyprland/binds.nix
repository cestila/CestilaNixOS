{
  host,
  lib,
  ...
}: let
  vars = import ../../../hosts/${host}/variables.nix;
  inherit
    (vars)
    barChoice
    browser
    terminal
    ;

  isDux = barChoice == "dux-shell" || barChoice == "dux" || barChoice == "dms";
  isCestila = barChoice == "cestila-shell" || barChoice == "cestila";
  isNoctalia = barChoice == "noctalia";
  isSerpantinum = barChoice == "serpantinum";
in {
  xdg.configFile."hypr/lua/binds.lua".text = ''
    -- Keybinds and Mousebinds for Hyprland
    local mod = "SUPER"

    -- ============= TERMINAL & BROWSER =============
    hl.bind(mod .. " + Return", hl.dsp.exec_cmd("${terminal}"))
    hl.bind(mod .. " + CTRL + Return", hl.dsp.exec_cmd("ghostty -e tmux"))
    hl.bind(mod .. " + W", hl.dsp.exec_cmd("${browser}"))
    hl.bind(mod .. " + Y", hl.dsp.exec_cmd("ghostty -e yazi"))
    hl.bind(mod .. " + T", hl.dsp.exec_cmd("pcmanfm"))
    hl.bind(mod .. " + E", hl.dsp.exec_cmd("emopicker9000"))
    hl.bind(mod .. " + K", hl.dsp.exec_cmd("qs-keybinds"))
    hl.bind(mod .. " + CTRL + C", hl.dsp.exec_cmd("qs-cheatsheets"))
    hl.bind(mod .. " + O", hl.dsp.exec_cmd("obs"))
    hl.bind(mod .. " + G", hl.dsp.exec_cmd("gimp"))
    hl.bind(mod .. " + N", hl.dsp.exec_cmd("obsidian"))
    hl.bind(mod .. " + ALT + C", hl.dsp.exec_cmd("hyprpicker -a"))
    hl.bind(mod .. " + ALT + M", hl.dsp.exec_cmd("pavucontrol"))

    -- ============= SHELL SPECIFIC BINDS =============
    ${if isDux then ''
    -- Dux Shell (DMS) Binds
    hl.bind(mod .. " + space", hl.dsp.exec_cmd("dms ipc spotlight toggle"))
    hl.bind(mod .. " + D", hl.dsp.exec_cmd("dms ipc spotlight toggle"))
    hl.bind(mod .. " + V", hl.dsp.exec_cmd("dms ipc clipboard toggle"))
    hl.bind(mod .. " + X", hl.dsp.exec_cmd("dms ipc powermenu toggle"))
    hl.bind(mod .. " + comma", hl.dsp.exec_cmd("dms ipc settings toggle"))
    hl.bind(mod .. " + P", hl.dsp.exec_cmd("dms ipc notepad toggle"))
    hl.bind(mod .. " + ALT + L", hl.dsp.exec_cmd("dms ipc lock lock"))
    hl.bind(mod .. " + ALT + N", hl.dsp.exec_cmd("dms ipc night toggle"))
    '' else if isCestila then ''
    -- Cestila Shell Binds
    hl.bind(mod .. " + space", hl.dsp.exec_cmd("quickshell -p ~/.config/quickshell/cestila-shell/shell.qml ipc call palette toggle"))
    hl.bind(mod .. " + D", hl.dsp.exec_cmd("quickshell -p ~/.config/quickshell/cestila-shell/shell.qml ipc call palette toggle"))
    hl.bind(mod .. " + S", hl.dsp.exec_cmd("quickshell -p ~/.config/quickshell/cestila-shell/shell.qml ipc call sidebar toggle"))
    hl.bind(mod .. " + H", hl.dsp.exec_cmd("quickshell -p ~/.config/quickshell/cestila-shell/shell.qml ipc call sidebar toggle"))
    hl.bind(mod .. " + grave", hl.dsp.workspace.toggle_special("herdr"))
    hl.bind(mod .. " + SHIFT + Return", hl.dsp.workspace.toggle_special("herdr"))
    hl.bind(mod .. " + ALT + L", hl.dsp.exec_cmd("loginctl lock-session"))
    '' else if isNoctalia then ''
    -- Noctalia Binds
    hl.bind(mod .. " + D", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
    hl.bind(mod .. " + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
    hl.bind(mod .. " + C", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"))
    hl.bind(mod .. " + X", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))
    '' else ''
    -- Default / Rofi Binds
    hl.bind(mod .. " + D", hl.dsp.exec_cmd("rofi-launcher"))
    hl.bind(mod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
    ''}

    -- ============= SCREENSHOTS =============
    hl.bind("Print", hl.dsp.exec_cmd("screenshootin"))
    hl.bind(mod .. " + CTRL + S", hl.dsp.exec_cmd("hyprshot -m output -o $HOME/Pictures/ScreenShots"))
    hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m window -o $HOME/Pictures/ScreenShots"))
    hl.bind(mod .. " + ALT + S", hl.dsp.exec_cmd("hyprshot -m region -o $HOME/Pictures/ScreenShots"))

    -- ============= WINDOW MANAGEMENT =============
    hl.bind(mod .. " + Q", hl.dsp.window.close())
    hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
    hl.bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
    hl.bind(mod .. " + P", hl.dsp.window.pseudo())
    hl.bind(mod .. " + SHIFT + I", hl.dsp.layout("togglesplit"))
    hl.bind(mod .. " + SHIFT + C", hl.dsp.exit())

    -- ============= FOCUS MOVEMENT (ARROW KEYS) =============
    hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "left" }))
    hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
    hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "up" }))
    hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "down" }))

    -- ============= FOCUS MOVEMENT (VIM KEYS) =============
    hl.bind(mod .. " + h", hl.dsp.focus({ direction = "left" }))
    hl.bind(mod .. " + l", hl.dsp.focus({ direction = "right" }))
    hl.bind(mod .. " + k", hl.dsp.focus({ direction = "up" }))
    hl.bind(mod .. " + j", hl.dsp.focus({ direction = "down" }))

    -- ============= WINDOW MOVEMENT (ARROW KEYS) =============
    hl.bind(mod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
    hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
    hl.bind(mod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
    hl.bind(mod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

    -- ============= WINDOW MOVEMENT (VIM KEYS) =============
    hl.bind(mod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
    hl.bind(mod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
    hl.bind(mod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
    hl.bind(mod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

    -- ============= WINDOW SWAPPING =============
    hl.bind(mod .. " + ALT + left",  hl.dsp.window.swap({ direction = "left" }))
    hl.bind(mod .. " + ALT + right", hl.dsp.window.swap({ direction = "right" }))
    hl.bind(mod .. " + ALT + up",    hl.dsp.window.swap({ direction = "up" }))
    hl.bind(mod .. " + ALT + down",  hl.dsp.window.swap({ direction = "down" }))

    -- ============= WORKSPACES 1-10 =============
    for i = 1, 10 do
        local key = tostring(i % 10)
        hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
        hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    end

    -- ============= SPECIAL WORKSPACE =============
    hl.bind(mod .. " + SHIFT + space", hl.dsp.window.move({ workspace = "special" }))
    hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))

    -- ============= WORKSPACE NAVIGATION =============
    hl.bind(mod .. " + CTRL + right", hl.dsp.focus({ workspace = "e+1" }))
    hl.bind(mod .. " + CTRL + left",  hl.dsp.focus({ workspace = "e-1" }))
    hl.bind(mod .. " + mouse_down",   hl.dsp.focus({ workspace = "e+1" }))
    hl.bind(mod .. " + mouse_up",     hl.dsp.focus({ workspace = "e-1" }))

    -- ============= WINDOW CYCLING =============
    hl.bind("ALT + Tab", hl.dsp.window.cycle_next())

    -- ============= MOUSE DRAGGING =============
    hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
    hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

    -- ============= HARDWARE & MEDIA KEYS =============
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
    hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
    hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"),                            { locked = true })
    hl.bind("XF86AudioPause",       hl.dsp.exec_cmd("playerctl play-pause"),                            { locked = true })
    hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"),                                  { locked = true })
    hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"),                              { locked = true })
    hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl set 5%-"),                           { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl set +5%"),                          { locked = true, repeating = true })
  '';
}
