# Cestila Shell Integration

Branch: `feat/cestila-shell-integration`

## Decisions
- Uncommitted WIP committed as baseline (3c6806a).
- Sidebar reserves screen space and docks to the top bar as one continuous surface.
- Palette, sidebar and calendar appear only on the focused monitor.
- System tray: left click focuses the app window, right click opens the native SNI menu (so the app can be quit from it).
- nm-applet and blueman-applet must not autostart; the shell indicators replace them.

## Tasks
- [x] Task 1: Baseline — branch and commit WIP. Evidence: 3c6806a
- [x] Task 2: Reliable startup — remove manual quickshell symlinks, launch cestila-shell (and overview) via declarative absolute package path / systemd user service; IPC binds use the same binary. Evidence: 5df2d66; after switch the service runs /nix/store/6q6kk7…-quickshell, 0 EGL errors, bar layers 1920x30 on both monitors (screenshot). Pending: confirm on a fresh login.
- [x] Task 3: Disable nm-applet / blueman-applet XDG autostart for non-waybar bars (shared module, reuse noctalia pattern). Evidence: 1dafeaa; ~/.config/autostart has Hidden=true overrides, applets no longer running.
- [x] Task 4: Sidebar docks to the bar — no double top offset, reserves space, keeps width during slide animation, focused monitor only. Evidence: a7493f0; layershell xywh shows y=30 right below the bar, reserved area shrinks workspace by 380px while open, seamlessly merges bar background with no border line across the joint, tested on both eDP-1 and HDMI-A-1 individually.
- [x] Task 5: Palette & calendar — single instance on focused monitor, relative get_apps.py path, attached to bar bottom edge. Evidence: 801c5aa; both surfaces dock flush to bar bottom (y = barHeight), only render on focused monitor (tested individually on eDP-1 and HDMI-A-1), relative script resolution via dirname of shell.qml (screenshots verified).
- [x] Task 6: SysTray — generic focus by app id, native SNI menu on right click, no per-app hacks. Evidence: 5a1b825; QsMenuAnchor renders native DBus context menu on right click for items advertising hasMenu (Telegram, ZapZap), left click activates SNI and uses generic token matching against hyprctl clients -j to switch workspace and focus by address, verified live on HDMI-A-1 (screenshot).

## Root cause notes
- Hyprland PATH puts `~/.npm-global/bin` first; its `quickshell` symlink points to a stale store path -> EGL unavailable -> layer-shell surfaces fail to render.
- Applets come from systemd xdg-autostart (`hyprland.nix` enableXdgAutostart).
