{pkgs}:
pkgs.writeShellScriptBin "vpn-rofi" ''
  #!/usr/bin/env bash
  set -euo pipefail

  if ! command -v nmcli >/dev/null 2>&1; then
    ${pkgs.libnotify}/bin/notify-send "VPN" "nmcli is not installed" -u critical
    exit 1
  fi

  # Build list of VPN connections (name|state)
  list=$(nmcli -t -f NAME,TYPE,STATE connection show \
    | awk -F: '$2 ~ /vpn|wireguard|openconnect|tailscale/ {print $1 "|" $3}' \
    | sort -u)

  if [ -z "$list" ]; then
    ${pkgs.libnotify}/bin/notify-send "VPN" "No VPN connections found" -i network-vpn
    exit 0
  fi

  # Build rofi menu, one per line, marking active ones with a leading ●
  menu=""
  while IFS='|' read -r name state; do
    [ -z "$name" ] && continue
    is_on=0
    if [ "$state" = "activated" ]; then
      is_on=1
    elif [ -r /etc/vpn-systemd-map ]; then
      unit=$(awk -F= -v n="$name" '$1 == n {print $2; exit}' /etc/vpn-systemd-map)
      if [ -n "$unit" ] && systemctl is-active --quiet "$unit" 2>/dev/null; then
        is_on=1
      fi
    fi

    if [ "$is_on" -eq 1 ]; then
      marker="● "
    else
      marker="○ "
    fi
    menu+="''${marker}''${name}"$'\n'
  done <<< "$list"

  picked=$(printf '%s' "$menu" | ${pkgs.rofi}/bin/rofi -dmenu \
    -p "VPN" \
    -mesg "● active   ○ inactive" \
    -i \
    -theme-str 'listview { lines: 8; }')

  [ -z "$picked" ] && exit 0

  # Strip the marker and any leading/trailing whitespace
  name=$(printf '%s' "$picked" | sed -e 's/^[●○][[:space:]]*//' -e 's/[[:space:]]*$//')

  vpn-ctl "$name" toggle
''
