import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import ".."

Item {
    id: root

    property int activeWorkspaceId: 1
    property var occupiedWorkspaces: [1]

    implicitHeight: 26
    implicitWidth: rowLayout.implicitWidth

    function updateWorkspaces() {
        getActiveWsProc.running = true;
        getWorkspacesProc.running = true;
    }

    Component.onCompleted: {
        updateWorkspaces();
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (!event) return;
            if (event.name === "workspace") {
                var targetId = parseInt(event.data);
                if (!isNaN(targetId)) {
                    root.activeWorkspaceId = targetId;
                }
            } else if (event.name === "createworkspace" ||
                       event.name === "destroyworkspace" ||
                       event.name === "movewindow" ||
                       event.name === "openwindow" ||
                       event.name === "closewindow" ||
                       event.name === "focusedmon") {
                root.updateWorkspaces();
            }
        }
    }

    Timer {
        interval: 1500
        running: true
        repeat: true
        onTriggered: root.updateWorkspaces()
    }

    Process {
        id: getActiveWsProc
        command: ["hyprctl", "activeworkspace", "-j"]
        stdout: StdioCollector {
            id: activeWsCol
            onStreamFinished: {
                try {
                    var data = JSON.parse(activeWsCol.text);
                    if (data && data.id) {
                        root.activeWorkspaceId = data.id;
                    }
                } catch(e) {}
            }
        }
    }

    Process {
        id: getWorkspacesProc
        command: ["hyprctl", "workspaces", "-j"]
        stdout: StdioCollector {
            id: wsCol
            onStreamFinished: {
                try {
                    var list = JSON.parse(wsCol.text);
                    var ids = [];
                    for (var i = 0; i < list.length; i++) {
                        ids.push(list[i].id);
                    }
                    root.occupiedWorkspaces = ids;
                } catch(e) {}
            }
        }
    }

    Process {
        id: switchWsProc
        property int targetWs: 1
        command: ["hyprctl", "dispatch", "workspace", targetWs.toString()]
    }

    function switchToWorkspace(wsId) {
        root.activeWorkspaceId = wsId;
        try {
            Hyprland.dispatch("workspace " + wsId);
        } catch(e) {
            switchWsProc.targetWs = wsId;
            switchWsProc.running = true;
        }
    }

    RowLayout {
        id: rowLayout
        anchors.verticalCenter: parent.verticalCenter
        spacing: 5

        Repeater {
            model: 6

            Rectangle {
                id: capsule
                required property int index
                readonly property int wsId: index + 1
                readonly property bool isActive: root.activeWorkspaceId === wsId
                readonly property bool isOccupied: root.occupiedWorkspaces.indexOf(wsId) !== -1

                implicitHeight: 22
                implicitWidth: isActive ? 30 : 22
                radius: height / 2

                color: isActive
                    ? Theme.accent
                    : (capsuleArea.containsMouse ? Theme.surface : (isOccupied ? Theme.surfaceSolid : "transparent"))

                border.color: isActive
                    ? Theme.accent
                    : (capsuleArea.containsMouse ? Theme.borderHighlight : (isOccupied ? Theme.borderHighlight : Theme.border))
                border.width: 1

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: Theme.animNormal
                        easing.type: Theme.easingOut
                    }
                }

                Behavior on color {
                    ColorAnimation { duration: Theme.animFast }
                }

                Behavior on border.color {
                    ColorAnimation { duration: Theme.animFast }
                }

                Text {
                    anchors.centerIn: parent
                    text: capsule.wsId.toString()
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: capsule.isActive
                    color: capsule.isActive
                        ? Theme.bgSolid
                        : (capsule.isOccupied ? Theme.fgBright : Theme.fgMuted)

                    Behavior on color {
                        ColorAnimation { duration: Theme.animFast }
                    }
                }

                MouseArea {
                    id: capsuleArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onClicked: {
                        root.switchToWorkspace(capsule.wsId);
                    }
                }
            }
        }
    }
}
