import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Widgets
import qs.Services.UI
import qs.Services.System

Item {
  id: root

  property var pluginApi: null
  property ShellScreen screen
  property string widgetId: ""
  property string section: ""
  property int sectionWidgetIndex: -1
  property int sectionWidgetsCount: 0

  readonly property var mainInstance: pluginApi?.mainInstance
  readonly property bool isConnected: mainInstance && mainInstance.vpnConnected
  readonly property string activeName: mainInstance ? mainInstance.activeVpnName : ""

  readonly property string barPosition: Settings.data.bar.position || "top"
  readonly property bool barIsVertical: barPosition === "left" || barPosition === "right"

  readonly property real contentWidth: {
    if (barIsVertical) return Style.capsuleHeight
    if (isConnected && activeName !== "") return contentRow.implicitWidth + Style.marginM * 2
    return Style.capsuleHeight
  }
  readonly property real contentHeight: Style.capsuleHeight

  implicitWidth: contentWidth
  implicitHeight: contentHeight

  Rectangle {
    id: visualCapsule
    x: Style.pixelAlignCenter(parent.width, width)
    y: Style.pixelAlignCenter(parent.height, height)
    width: root.contentWidth
    height: root.contentHeight
    color: {
      if (mouseArea.containsMouse && !isConnected)
        return Color.mHover
      return Style.capsuleColor
    }
    radius: Style.radiusL

    RowLayout {
      id: contentRow
      anchors.centerIn: parent
      spacing: Style.marginS
      layoutDirection: Qt.LeftToRight

      NIcon {
        icon: isConnected ? "shield-lock" : "shield"
        applyUiScale: false
        color: {
          if (isConnected) return Color.mPrimary
          return mouseArea.containsMouse ? Color.mOnHover : Color.mOnSurface
        }
      }

      NText {
        visible: !barIsVertical && isConnected && activeName !== ""
        family: Settings.data.ui.fontFixed
        pointSize: Style.barFontSize
        text: activeName
        color: isConnected ? Color.mPrimary : (mouseArea.containsMouse ? Color.mOnHover : Color.mOnSurface)
      }
    }
  }

  NPopupContextMenu {
    id: contextMenu

    model: {
      var items = [];
      if (mainInstance && mainInstance.vpnList && mainInstance.vpnList.length > 0) {
        for (var i = 0; i < mainInstance.vpnList.length; i++) {
          var vpn = mainInstance.vpnList[i];
          items.push({
            "label": (vpn.active ? "✓ " : "  ") + vpn.name + " (" + vpn.type + ")",
            "action": "vpn:" + vpn.name + ":" + (vpn.active ? "down" : "up")
          });
        }
      } else {
        items.push({
          "label": "No hay VPNs configuradas",
          "action": "none"
        });
      }
      items.push({
        "label": "Selector VPN (vpn-rofi)...",
        "action": "open-rofi"
      });
      items.push({
        "label": "Actualizar estado",
        "action": "refresh"
      });
      return items;
    }

    onTriggered: action => {
      contextMenu.close();
      PanelService.closeContextMenu(screen);

      if (!mainInstance) return;

      if (action.startsWith("vpn:")) {
        var parts = action.split(":");
        var vpnName = parts[1];
        var dir = parts[2];
        if (dir === "down") {
          mainInstance.disconnectVpn(vpnName);
        } else {
          mainInstance.connectVpn(vpnName);
        }
      } else if (action === "open-rofi") {
        mainInstance.openVpnRofi();
      } else if (action === "refresh") {
        mainInstance.fetchVpnStatus();
      }
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

    onClicked: (mouse) => {
      if (mouse.button === Qt.LeftButton) {
        if (pluginApi) {
          pluginApi.openPanel(root.screen, root);
        }
      } else if (mouse.button === Qt.RightButton) {
        PanelService.showContextMenu(contextMenu, root, screen);
      } else if (mouse.button === Qt.MiddleButton) {
        if (mainInstance) {
          mainInstance.openVpnRofi();
        }
      }
    }
  }
}
