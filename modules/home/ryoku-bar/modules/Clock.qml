import QtQuick
import QtQuick.Layouts
import ".."

Item {
    id: root

    property var currentTime: new Date()

    implicitHeight: 26
    implicitWidth: clockRow.implicitWidth

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            root.currentTime = new Date();
        }
    }

    function formatTime(date) {
        var h = date.getHours().toString().padStart(2, "0");
        var m = date.getMinutes().toString().padStart(2, "0");
        return h + ":" + m;
    }

    function formatDate(date) {
        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        return months[date.getMonth()] + " " + date.getDate();
    }

    RowLayout {
        id: clockRow
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        Text {
            text: ""
            font.family: Theme.monoFontFamily
            font.pixelSize: Theme.fontSizeNormal
            color: Theme.accent
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: root.formatTime(root.currentTime)
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeNormal
            font.bold: true
            color: Theme.fgBright
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: root.formatDate(root.currentTime)
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeNormal
            font.weight: Font.Medium
            color: Theme.fgMuted
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
