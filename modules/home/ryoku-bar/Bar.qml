import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "./modules"

PanelWindow {
    id: barWindow
    required property var modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Theme.barHeight
    color: "transparent"
    exclusionMode: ExclusionMode.Auto
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    // Continuous background with 1px bottom border
    Rectangle {
        anchors.fill: parent
        color: Theme.bg

        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            height: 1
            color: Theme.border
        }
    }

    Item {
        id: barContainer
        anchors {
            fill: parent
            leftMargin: 12
            rightMargin: 12
        }

        // Left: Workspaces + vertical divider + WindowTitle
        RowLayout {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            spacing: 10

            Workspaces {}

            Rectangle {
                implicitWidth: 1
                implicitHeight: 14
                color: Theme.border
                Layout.alignment: Qt.AlignVCenter
            }

            WindowTitle {}
        }

        // Center: Clock (time & date)
        RowLayout {
            anchors.centerIn: parent

            Clock {}
        }

        // Right: HardwareStats (CPU/RAM) + divider + AudioVolume + divider + Network + Battery + SysTray + PowerMenu
        RowLayout {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            spacing: 8

            HardwareStats {}

            Rectangle {
                implicitWidth: 1
                implicitHeight: 14
                color: Theme.border
                Layout.alignment: Qt.AlignVCenter
            }

            AudioVolume {}

            Rectangle {
                implicitWidth: 1
                implicitHeight: 14
                color: Theme.border
                Layout.alignment: Qt.AlignVCenter
            }

            Network {}

            Rectangle {
                implicitWidth: 1
                implicitHeight: 14
                color: Theme.border
                Layout.alignment: Qt.AlignVCenter
                visible: batteryModule.visible
            }

            Battery {
                id: batteryModule
            }

            Rectangle {
                implicitWidth: 1
                implicitHeight: 14
                color: Theme.border
                Layout.alignment: Qt.AlignVCenter
                visible: sysTrayModule.visible
            }

            SysTray {
                id: sysTrayModule
            }

            Rectangle {
                implicitWidth: 1
                implicitHeight: 14
                color: Theme.border
                Layout.alignment: Qt.AlignVCenter
            }

            PowerMenu {}
        }
    }
}
