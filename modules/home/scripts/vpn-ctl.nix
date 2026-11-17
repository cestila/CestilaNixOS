{pkgs}:
pkgs.writeShellScriptBin "vpn-ctl" ''
  #!/usr/bin/env bash
  set -euo pipefail

  VPN_NAME="''${1:-}"
  ACTION="''${2:-toggle}" # up, down, or toggle

  if [ -z "$VPN_NAME" ]; then
    echo "Usage: vpn-ctl <VPN_NAME> [up|down|toggle]"
    exit 1
  fi

  is_unit_active() {
    local unit="$1"
    systemctl is-active --quiet "$unit" 2>/dev/null
  }

  is_nm_active() {
    local st
    st=$(nmcli -t -f NAME,STATE connection show 2>/dev/null | awk -F: -v n="$VPN_NAME" '$1 == n {print $2; exit}')
    [ "$st" = "activated" ]
  }

  UNIT=""
  if [ -r /etc/vpn-systemd-map ]; then
    UNIT=$(awk -F= -v n="$VPN_NAME" '$1 == n {print $2; exit}' /etc/vpn-systemd-map)
  fi

  if [ -n "$UNIT" ]; then
    case "$ACTION" in
      "up")
        ${pkgs.libnotify}/bin/notify-send "VPN" "Conectando a $VPN_NAME..." -i network-vpn 2>/dev/null || true
        systemctl start "$UNIT"
        sleep 1
        if is_unit_active "$UNIT"; then
          ${pkgs.libnotify}/bin/notify-send "VPN" "Conectado: $VPN_NAME" -i network-vpn 2>/dev/null || true
        else
          ${pkgs.libnotify}/bin/notify-send "VPN" "Error al conectar: $VPN_NAME" -u critical 2>/dev/null || true
          exit 1
        fi
        ;;
      "down")
        systemctl stop "$UNIT"
        ${pkgs.libnotify}/bin/notify-send "VPN" "Desconectado: $VPN_NAME" -i network-vpn 2>/dev/null || true
        ;;
      "toggle")
        if is_unit_active "$UNIT"; then
          systemctl stop "$UNIT"
          ${pkgs.libnotify}/bin/notify-send "VPN" "Desconectado: $VPN_NAME" -i network-vpn 2>/dev/null || true
        else
          ${pkgs.libnotify}/bin/notify-send "VPN" "Conectando a $VPN_NAME..." -i network-vpn 2>/dev/null || true
          systemctl start "$UNIT"
          sleep 1
          if is_unit_active "$UNIT"; then
            ${pkgs.libnotify}/bin/notify-send "VPN" "Conectado: $VPN_NAME" -i network-vpn 2>/dev/null || true
          else
            ${pkgs.libnotify}/bin/notify-send "VPN" "Error al conectar: $VPN_NAME" -u critical 2>/dev/null || true
            exit 1
          fi
        fi
        ;;
    esac
  else
    case "$ACTION" in
      "up")
        if nmcli connection up "$VPN_NAME" >/dev/null 2>&1; then
          ${pkgs.libnotify}/bin/notify-send "VPN" "Conectado: $VPN_NAME" -i network-vpn 2>/dev/null || true
        else
          ${pkgs.libnotify}/bin/notify-send "VPN" "Error al conectar: $VPN_NAME" -u critical 2>/dev/null || true
          exit 1
        fi
        ;;
      "down")
        if nmcli connection down "$VPN_NAME" >/dev/null 2>&1; then
          ${pkgs.libnotify}/bin/notify-send "VPN" "Desconectado: $VPN_NAME" -i network-vpn 2>/dev/null || true
        fi
        ;;
      "toggle")
        if is_nm_active; then
          nmcli connection down "$VPN_NAME" >/dev/null 2>&1 || true
          ${pkgs.libnotify}/bin/notify-send "VPN" "Desconectado: $VPN_NAME" -i network-vpn 2>/dev/null || true
        else
          if nmcli connection up "$VPN_NAME" >/dev/null 2>&1; then
            ${pkgs.libnotify}/bin/notify-send "VPN" "Conectado: $VPN_NAME" -i network-vpn 2>/dev/null || true
          else
            ${pkgs.libnotify}/bin/notify-send "VPN" "Error al conectar: $VPN_NAME" -u critical 2>/dev/null || true
            exit 1
          fi
        fi
        ;;
    esac
  fi
''
