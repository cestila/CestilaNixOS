{
  host,
  lib,
  ...
}: let
  vars = import ../../../hosts/${host}/variables.nix;
  inherit (vars) barChoice stylixImage;

  noctaliaExec =
    if barChoice == "noctalia"
    then [
      "killall -q waybar; pkill -f waybar || true"
      "killall -q swaync; sleep .5 && swaync"
      "killall -q serpantinumd; pkill -f serpantinum || true"
      "systemctl --user stop dms.service || true"
      "nm-applet --indicator"
      "sh -lc 'sleep 2 && (qs-wallpapers-restore || waypaper --wallpaper ${stylixImage} --backend awww) >/dev/null 2>&1 || true'"
      "noctalia"
    ]
    else [];

  ryokuExec =
    if barChoice == "ryoku"
    then [
      "killall -q waybar; pkill -f waybar || true"
      "killall -q noctalia; pkill -f noctalia || true"
      "killall -q swaync; pkill -f swaync || true"
      "killall -q serpantinumd; pkill -f serpantinum || true"
      "systemctl --user stop dms.service || true"
      "killall -q awww; sleep .5 && awww-daemon"
      "sh -lc 'sleep 2 && (qs-wallpapers-restore || waypaper --wallpaper ${stylixImage} --backend awww) >/dev/null 2>&1 || true'"
      "ryoku"
    ]
    else [];

  cestilaExec =
    if barChoice == "cestila-shell" || barChoice == "cestila"
    then [
      "killall -q waybar; pkill -f waybar || true"
      "killall -q noctalia; pkill -f noctalia || true"
      "killall -q swaync; sleep .5 && swaync"
      "killall -q serpantinumd; pkill -f serpantinum || true"
      "systemctl --user stop dms.service || true"
      "killall -q awww; sleep .5 && awww-daemon"
      "sh -lc 'sleep 2 && (qs-wallpapers-restore || waypaper --wallpaper ${stylixImage} --backend awww) >/dev/null 2>&1 || true'"
      "nm-applet --indicator"
      "cestila-shell"
    ]
    else [];

  serpantinumExec =
    if barChoice == "serpantinum"
    then [
      "killall -q waybar; pkill -f waybar || true"
      "killall -q noctalia; pkill -f noctalia || true"
      "killall -q swaync; pkill -f swaync || true"
      "systemctl --user stop dms.service || true"
      "killall -q awww; sleep .5 && awww-daemon"
      "sh -lc 'sleep 2 && (qs-wallpapers-restore || waypaper --wallpaper ${stylixImage} --backend awww) >/dev/null 2>&1 || true'"
      "serpantinum"
    ]
    else [];

  duxExec =
    if barChoice == "dux-shell" || barChoice == "dux" || barChoice == "dms"
    then [
      "killall -q waybar; pkill -f waybar || true"
      "killall -q noctalia; pkill -f noctalia || true"
      "killall -q swaync; pkill -f swaync || true"
      "killall -q serpantinumd; pkill -f serpantinum || true"
      "killall -q awww; sleep .5 && awww-daemon"
      "sh -lc 'sleep 2 && (qs-wallpapers-restore || waypaper --wallpaper ${stylixImage} --backend awww) >/dev/null 2>&1 || true'"
      "systemctl --user restart dms.service"
    ]
    else [];

  waybarExec =
    if barChoice != "noctalia" && barChoice != "ryoku" && barChoice != "cestila-shell" && barChoice != "cestila" && barChoice != "serpantinum" && barChoice != "dux-shell" && barChoice != "dux" && barChoice != "dms"
    then [
      "killall -q waybar; sleep .5 && waybar"
      "killall -q noctalia; pkill -f noctalia || true"
      "killall -q swaync; sleep .5 && swaync"
      "killall -q serpantinumd; pkill -f serpantinum || true"
      "systemctl --user stop dms.service || true"
      "nm-applet --indicator"
      "sh -lc 'sleep 2 && (qs-wallpapers-restore || waypaper --wallpaper ${stylixImage} --backend awww) >/dev/null 2>&1 || true'"
    ]
    else [];

  allExec = [
    "wl-paste --type text --watch cliphist store"
    "wl-paste --type image --watch cliphist store"
    "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "systemctl --user start hyprpolkitagent"
    "systemctl --user start hyprland-session.target"
    "qs -c overview"
    "hyprland-change-layout init"
  ] ++ noctaliaExec ++ ryokuExec ++ cestilaExec ++ serpantinumExec ++ duxExec ++ waybarExec;

  formatExec = cmd: "    hl.exec_cmd([[" + cmd + "]])\n";
in {
  xdg.configFile."hypr/lua/autostart.lua".text = ''
    -- Autostart processes
    hl.on("hyprland.start", function ()
${lib.concatMapStrings formatExec allExec}
    end)
  '';
}
