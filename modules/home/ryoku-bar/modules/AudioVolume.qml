import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import ".."

Item {
    id: root

    property int volume: 50
    property bool muted: false

    implicitHeight: 26
    implicitWidth: rowLayout.implicitWidth

    function updateVolume() {
        getVolProc.running = true;
    }

    Component.onCompleted: {
        updateVolume();
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: root.updateVolume()
    }

    Process {
        id: getVolProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            id: volCol
            onStreamFinished: {
                var text = volCol.text.trim();
                root.muted = text.indexOf("[MUTED]") !== -1;
                var match = text.match(/([0-9]+(\.[0-9]+)?)/);
                if (match) {
                    root.volume = Math.round(parseFloat(match[1]) * 100);
                }
            }
        }
    }

    Process {
        id: execProc
        property var cmd: []
        command: cmd
        onExited: root.updateVolume()
    }

    function runCmd(args) {
        execProc.cmd = args;
        execProc.running = true;
    }

    function toggleMute() {
        runCmd(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]);
    }

    function changeVolume(delta) {
        if (delta > 0) {
            runCmd(["wpctl", "set-volume", "-l", "1.5", "@DEFAULT_AUDIO_SINK@", "5%+"]);
        } else {
            runCmd(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-"]);
        }
    }

    function getVolumeIcon() {
        if (root.muted || root.volume === 0) return "󰝟";
        if (root.volume < 33) return "";
        if (root.volume < 66) return "";
        return "";
    }

    RowLayout {
        id: rowLayout
        anchors.verticalCenter: parent.verticalCenter
        spacing: 5

        Text {
            text: root.getVolumeIcon()
            font.family: Theme.monoFontFamily
            font.pixelSize: Theme.fontSizeNormal
            color: root.muted ? Theme.red : Theme.accent
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: root.muted ? "Mute" : root.volume + "%"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
            font.weight: Font.Medium
            color: root.muted ? Theme.red : Theme.fg
            Layout.alignment: Qt.AlignVCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            root.toggleMute();
        }

        onWheel: wheel => {
            if (wheel.angleDelta.y > 0) {
                root.changeVolume(1);
            } else if (wheel.angleDelta.y < 0) {
                root.changeVolume(-1);
            }
        }
    }
}
