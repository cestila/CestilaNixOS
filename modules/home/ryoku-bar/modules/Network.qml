import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import ".."

Item {
    id: root

    property string netType: "none"
    property string ssid: "Desconectado"
    property bool connected: false

    implicitHeight: 26
    implicitWidth: rowLayout.implicitWidth

    function updateNetwork() {
        getNetProc.running = true;
    }

    Component.onCompleted: {
        updateNetwork();
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: root.updateNetwork()
    }

    Process {
        id: getNetProc
        command: ["sh", "-c", "LC_ALL=C nmcli -t -f TYPE,STATE,CONNECTION dev status | grep -E '^(wifi|ethernet):connected:' | head -n1"]
        stdout: StdioCollector {
            id: netCol
            onStreamFinished: {
                var out = netCol.text.trim();
                if (out) {
                    var parts = out.split(":");
                    root.netType = parts[0];
                    root.connected = true;
                    var name = parts.slice(2).join(":");
                    root.ssid = name && name.trim() !== "" ? name : (root.netType === "wifi" ? "Wi-Fi" : "Ethernet");
                } else {
                    root.connected = false;
                    root.netType = "none";
                    root.ssid = "Desconectado";
                }
            }
        }
    }

    function getNetIcon() {
        if (!root.connected) return "󰤭";
        if (root.netType === "ethernet") return "󰈀";
        return "󰤨";
    }

    RowLayout {
        id: rowLayout
        anchors.verticalCenter: parent.verticalCenter
        spacing: 5

        Text {
            text: root.getNetIcon()
            font.family: Theme.monoFontFamily
            font.pixelSize: Theme.fontSizeNormal
            color: root.connected ? Theme.cyan : Theme.fgMuted
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: root.ssid
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
            font.weight: Font.Medium
            color: root.connected ? Theme.fg : Theme.fgMuted
            elide: Text.ElideRight
            Layout.maximumWidth: 120
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
