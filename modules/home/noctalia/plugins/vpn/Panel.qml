import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.Commons
import qs.Services.System
import qs.Widgets

Item {
  id: root

  property var pluginApi: null
  readonly property var geometryPlaceholder: panelContainer
  readonly property bool allowAttach: true

  readonly property var mainInstance: pluginApi?.mainInstance
  readonly property bool panelReady: pluginApi !== null && mainInstance !== null && mainInstance !== undefined

  property real contentPreferredWidth: 360 * Style.uiScaleRatio
  property real contentPreferredHeight: Math.min(420 * Style.uiScaleRatio, Math.max(220 * Style.uiScaleRatio, ((mainInstance?.vpnList?.length || 0) * 48 + 120) * Style.uiScaleRatio))

  anchors.fill: parent

  Rectangle {
    id: panelContainer
    anchors.fill: parent
    color: "transparent"
    visible: panelReady

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: Style.marginM
      spacing: Style.marginM

      NBox {
        Layout.fillWidth: true
        Layout.fillHeight: true

        ColumnLayout {
          anchors.fill: parent
          anchors.margins: Style.marginM
          spacing: Style.marginM

          RowLayout {
            Layout.fillWidth: true
            spacing: Style.marginS

            NIcon {
              icon: mainInstance?.vpnConnected ? "shield-lock" : "shield"
              pointSize: Style.fontSizeL
              color: mainInstance?.vpnConnected ? Color.mPrimary : Color.mOnSurface
            }

            NText {
              text: "VPN & WireGuard"
              pointSize: Style.fontSizeL
              font.weight: Style.fontWeightBold
              color: Color.mOnSurface
              Layout.fillWidth: true
            }

            NIconButton {
              icon: "refresh"
              tooltipText: "Actualizar"
              onClicked: if (mainInstance) mainInstance.fetchVpnStatus()
            }
          }

          NDivider {
            Layout.fillWidth: true
          }

          ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
              width: parent.width
              spacing: Style.marginS

              Repeater {
                model: mainInstance?.vpnList || []

                Rectangle {
                  Layout.fillWidth: true
                  Layout.preferredHeight: 42 * Style.uiScaleRatio
                  radius: Style.radiusM
                  color: modelData.active ? Color.mPrimaryContainer : Color.mSurfaceVariant

                  RowLayout {
                    anchors.fill: parent
                    anchors.margins: Style.marginS
                    spacing: Style.marginS

                    NIcon {
                      icon: modelData.active ? "shield-check" : "shield"
                      color: modelData.active ? Color.mPrimary : Color.mOnSurfaceVariant
                    }

                    ColumnLayout {
                      Layout.fillWidth: true
                      spacing: 0

                      NText {
                        text: modelData.name
                        font.weight: modelData.active ? Style.fontWeightBold : Style.fontWeightRegular
                        color: modelData.active ? Color.mOnPrimaryContainer : Color.mOnSurface
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                      }

                      NText {
                        text: modelData.type
                        pointSize: Style.fontSizeS
                        color: Color.mOutline
                      }
                    }

                    NButton {
                      text: modelData.active ? "Desconectar" : "Conectar"
                      primary: !modelData.active
                      onClicked: {
                        if (mainInstance) {
                          mainInstance.toggleVpn(modelData.name, modelData.active);
                        }
                      }
                    }
                  }
                }
              }

              NText {
                visible: (mainInstance?.vpnList?.length || 0) === 0
                text: "No se encontraron conexiones VPN configuradas en NetworkManager."
                color: Color.mOutline
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter
              }
            }
          }

          NDivider {
            Layout.fillWidth: true
          }

          NButton {
            Layout.fillWidth: true
            text: "Abrir selector avanzado (vpn-rofi)"
            icon: "external-link"
            onClicked: {
              if (mainInstance) {
                mainInstance.openVpnRofi();
              }
            }
          }
        }
      }
    }
  }
}
