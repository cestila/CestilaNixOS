import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import ".."

Item {
    id: root

    property int capacity: 100
    property string status: "Full"
    property bool isCharging: status === "Charging"
    property bool hasBattery: true

    implicitHeight: 26
    implicitWidth: hasBattery ? rowLayout.implicitWidth : 0
    visible: hasBattery

    FileView {
        id: capView
        path: "/sys/class/power_supply/BAT0/capacity"
        watchChanges: false
        printErrors: false
        onLoaded: {
            root.hasBattery = true;
            var val = parseInt(text().trim());
            if (!isNaN(val)) root.capacity = val;
        }
        onLoadFailed: {
            altCapView.reload();
        }
    }

    FileView {
        id: statusView
        path: "/sys/class/power_supply/BAT0/status"
        watchChanges: false
        printErrors: false
        onLoaded: {
            root.status = text().trim();
        }
        onLoadFailed: {
            altStatusView.reload();
        }
    }

    FileView {
        id: altCapView
        path: "/sys/class/power_supply/BAT1/capacity"
        watchChanges: false
        printErrors: false
        onLoaded: {
            root.hasBattery = true;
            var val = parseInt(text().trim());
            if (!isNaN(val)) root.capacity = val;
        }
        onLoadFailed: {
            root.hasBattery = false;
        }
    }

    FileView {
        id: altStatusView
        path: "/sys/class/power_supply/BAT1/status"
        watchChanges: false
        printErrors: false
        onLoaded: {
            root.status = text().trim();
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            capView.reload();
            statusView.reload();
        }
    }

    function getBatteryIcon() {
        if (root.isCharging) return "󰂄";
        if (root.capacity >= 90) return "󰁹";
        if (root.capacity >= 70) return "󰂁";
        if (root.capacity >= 50) return "󰁿";
        if (root.capacity >= 30) return "󰁽";
        if (root.capacity >= 15) return "󰁻";
        return "󰁺";
    }

    function getBatteryColor() {
        if (root.isCharging) return Theme.green;
        if (root.capacity <= 20) return Theme.red;
        if (root.capacity <= 35) return Theme.orange;
        return Theme.fg;
    }

    RowLayout {
        id: rowLayout
        anchors.verticalCenter: parent.verticalCenter
        spacing: 5

        Text {
            text: root.getBatteryIcon()
            font.family: Theme.monoFontFamily
            font.pixelSize: Theme.fontSizeNormal
            color: root.getBatteryColor()
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: root.capacity + "%"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
            font.weight: Font.Medium
            color: root.getBatteryColor()
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
