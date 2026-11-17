import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import ".."

Item {
    id: root

    implicitHeight: 26
    implicitWidth: rowLayout.implicitWidth
    visible: trayRepeater.count > 0

    function resolveIcon(icon) {
        if (!icon || icon === "") return "";
        if (icon.startsWith("/") || icon.startsWith("file:") || icon.startsWith("image:")) {
            return icon;
        }
        return Quickshell.iconPath(icon);
    }

    RowLayout {
        id: rowLayout
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        Repeater {
            id: trayRepeater
            model: SystemTray.items

            Item {
                id: trayDelegate
                required property var modelData

                implicitWidth: 20
                implicitHeight: 20

                IconImage {
                    anchors.centerIn: parent
                    implicitSize: 16
                    source: root.resolveIcon(trayDelegate.modelData ? trayDelegate.modelData.icon : "")
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    onClicked: mouse => {
                        if (!trayDelegate.modelData) return;
                        if (mouse.button === Qt.RightButton) {
                            trayDelegate.modelData.secondaryActivate();
                        } else {
                            trayDelegate.modelData.activate();
                        }
                    }
                }
            }
        }
    }
}
