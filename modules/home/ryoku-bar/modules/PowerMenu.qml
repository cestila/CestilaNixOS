import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Item {
    id: root

    property bool isHovered: false

    implicitHeight: 26
    implicitWidth: 26

    Process {
        id: wlogoutProc
        command: ["wlogout"]
    }

    Rectangle {
        id: bgCircle
        anchors.fill: parent
        radius: height / 2
        color: root.isHovered ? Theme.surfaceSolid : "transparent"
        border.color: root.isHovered ? Theme.red : "transparent"
        border.width: 1

        Behavior on color {
            ColorAnimation { duration: Theme.animFast }
        }

        Text {
            anchors.centerIn: parent
            text: ""
            font.family: Theme.monoFontFamily
            font.pixelSize: Theme.fontSizeNormal
            font.bold: true
            color: root.isHovered ? Theme.red : Theme.fgMuted

            Behavior on color {
                ColorAnimation { duration: Theme.animFast }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true

            onEntered: root.isHovered = true
            onExited: root.isHovered = false

            onClicked: {
                wlogoutProc.running = true;
            }
        }
    }
}
