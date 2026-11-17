import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import ".."

Item {
    id: root

    property string windowTitle: "Desktop"
    property string windowClass: ""
    property int maxTitleWidth: 280

    implicitHeight: 26
    implicitWidth: rowLayout.implicitWidth

    function updateTitle() {
        getTitleProc.running = true;
    }

    Component.onCompleted: {
        updateTitle();
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (!event) return;
            if (event.name === "activewindow" ||
                event.name === "activewindowv2" ||
                event.name === "closewindow" ||
                event.name === "workspace" ||
                event.name === "focusedmon") {
                root.updateTitle();
            }
        }
    }

    Timer {
        interval: 1500
        running: true
        repeat: true
        onTriggered: root.updateTitle()
    }

    Process {
        id: getTitleProc
        command: ["hyprctl", "activewindow", "-j"]
        stdout: StdioCollector {
            id: titleCol
            onStreamFinished: {
                try {
                    var data = JSON.parse(titleCol.text);
                    if (data && data.title && data.title.trim() !== "") {
                        root.windowTitle = data.title;
                        root.windowClass = data.class || "";
                    } else {
                        root.windowTitle = "Desktop";
                        root.windowClass = "";
                    }
                } catch(e) {
                    root.windowTitle = "Desktop";
                    root.windowClass = "";
                }
            }
        }
    }

    RowLayout {
        id: rowLayout
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        Rectangle {
            implicitWidth: 6
            implicitHeight: 6
            radius: 3
            color: root.windowTitle !== "Desktop" ? Theme.cyan : Theme.fgMuted
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            id: titleText
            text: root.windowTitle
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeNormal
            font.weight: Font.Medium
            color: root.windowTitle !== "Desktop" ? Theme.fg : Theme.fgMuted
            elide: Text.ElideRight
            Layout.preferredWidth: Math.min(implicitWidth, root.maxTitleWidth)
            Layout.maximumWidth: root.maxTitleWidth
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
