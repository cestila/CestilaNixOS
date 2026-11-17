import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Services.System
import qs.Services.UI

Item {
  id: root

  property var pluginApi: null

  property bool vpnConnected: false
  property string activeVpnName: ""
  property var vpnList: []

  Timer {
    id: refreshTimer
    interval: 3000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: fetchVpnStatus()
  }

  Process {
    id: statusProc
    command: ["sh", "-c", "nmcli -t -f NAME,TYPE,STATE connection show 2>/dev/null | while IFS=: read -r n t s; do if [ -r /etc/vpn-systemd-map ]; then u=$(awk -F= -v n=\"$n\" '$1 == n {print $2; exit}' /etc/vpn-systemd-map); if [ -n \"$u\" ] && systemctl is-active --quiet \"$u\" 2>/dev/null; then s=\"activated\"; fi; fi; echo \"$n:$t:$s\"; done"]
    
    stdout: SplitParser {
      split: "\n"
      onRead: line => {
        if (!line || line.trim() === "") return;
        var parts = line.split(":");
        if (parts.length >= 2) {
          var name = parts[0];
          var type = parts[1].toLowerCase();
          var state = parts.length >= 3 ? parts[2].toLowerCase() : "";
          
          if (type.includes("vpn") || type.includes("wireguard") || type.includes("openconnect") || type.includes("forti") || type.includes("tailscale")) {
            var isActive = (state === "activated" || state === "activating");
            pendingList.push({
              name: name,
              type: type,
              active: isActive
            });
            if (isActive) {
              hasActive = true;
              activeName = name;
            }
          }
        }
      }
    }

    property var pendingList: []
    property bool hasActive: false
    property string activeName: ""

    onStarted: {
      pendingList = [];
      hasActive = false;
      activeName = "";
    }

    onExited: (code, status) => {
      root.vpnList = pendingList;
      root.vpnConnected = hasActive;
      root.activeVpnName = activeName;
    }
  }

  Process {
    id: actionProc
    onExited: {
      refreshTimer.restart();
      fetchVpnStatus();
    }
  }

  function fetchVpnStatus() {
    if (!statusProc.running) {
      statusProc.running = true;
    }
  }

  function toggleVpn(name, currentlyActive) {
    if (currentlyActive) {
      disconnectVpn(name);
    } else {
      connectVpn(name);
    }
  }

  function connectVpn(name) {
    actionProc.command = ["vpn-ctl", name, "up"];
    actionProc.running = true;
  }

  function disconnectVpn(name) {
    actionProc.command = ["vpn-ctl", name, "down"];
    actionProc.running = true;
  }

  function openVpnRofi() {
    actionProc.command = ["vpn-rofi"];
    actionProc.running = true;
  }
}
