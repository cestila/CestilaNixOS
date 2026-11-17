import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import ".."

Item {
    id: root

    property int cpuPercent: 0
    property int ramPercent: 0

    // Stored for CPU delta calculation
    property real lastTotalTime: 0
    property real lastIdleTime: 0

    implicitHeight: 26
    implicitWidth: rowLayout.implicitWidth

    FileView {
        id: statView
        path: "/proc/stat"
        watchChanges: false
        onLoaded: {
            try {
                var firstLine = text().split("\n")[0];
                var parts = firstLine.trim().split(/\s+/).slice(1);
                if (parts.length >= 4) {
                    var user = parseFloat(parts[0]) || 0;
                    var nice = parseFloat(parts[1]) || 0;
                    var system = parseFloat(parts[2]) || 0;
                    var idle = parseFloat(parts[3]) || 0;
                    var iowait = parseFloat(parts[4]) || 0;
                    var irq = parseFloat(parts[5]) || 0;
                    var softirq = parseFloat(parts[6]) || 0;
                    var steal = parseFloat(parts[7]) || 0;

                    var total = user + nice + system + idle + iowait + irq + softirq + steal;
                    var currentIdle = idle + iowait;

                    if (root.lastTotalTime > 0) {
                        var diffTotal = total - root.lastTotalTime;
                        var diffIdle = currentIdle - root.lastIdleTime;
                        if (diffTotal > 0) {
                            var usage = Math.round(100 * (diffTotal - diffIdle) / diffTotal);
                            root.cpuPercent = Math.min(Math.max(usage, 0), 100);
                        }
                    }

                    root.lastTotalTime = total;
                    root.lastIdleTime = currentIdle;
                }
            } catch(e) {}
        }
    }

    FileView {
        id: memView
        path: "/proc/meminfo"
        watchChanges: false
        onLoaded: {
            try {
                var lines = text().split("\n");
                var totalKb = 0;
                var availKb = 0;
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i];
                    if (line.startsWith("MemTotal:")) {
                        totalKb = parseInt(line.replace(/[^0-9]/g, "")) || 0;
                    } else if (line.startsWith("MemAvailable:")) {
                        availKb = parseInt(line.replace(/[^0-9]/g, "")) || 0;
                    }
                }
                if (totalKb > 0) {
                    var usedKb = totalKb - availKb;
                    root.ramPercent = Math.round((usedKb / totalKb) * 100);
                }
            } catch(e) {}
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            statView.reload();
            memView.reload();
        }
    }

    function getLoadColor(percent) {
        if (percent >= 85) return Theme.red;
        if (percent >= 70) return Theme.orange;
        return Theme.fg;
    }

    RowLayout {
        id: rowLayout
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        // CPU Badge
        Rectangle {
            implicitHeight: 22
            implicitWidth: cpuContent.implicitWidth + 12
            radius: Theme.badgeRadius
            color: Theme.surfaceSolid
            border.color: Theme.border
            border.width: 1

            RowLayout {
                id: cpuContent
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: ""
                    font.family: Theme.monoFontFamily
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.cyan
                }

                Text {
                    text: root.cpuPercent + "%"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                    font.weight: Font.Medium
                    color: root.getLoadColor(root.cpuPercent)
                }
            }
        }

        // RAM Badge
        Rectangle {
            implicitHeight: 22
            implicitWidth: ramContent.implicitWidth + 12
            radius: Theme.badgeRadius
            color: Theme.surfaceSolid
            border.color: Theme.border
            border.width: 1

            RowLayout {
                id: ramContent
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: ""
                    font.family: Theme.monoFontFamily
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.purple
                }

                Text {
                    text: root.ramPercent + "%"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                    font.weight: Font.Medium
                    color: root.getLoadColor(root.ramPercent)
                }
            }
        }
    }
}
