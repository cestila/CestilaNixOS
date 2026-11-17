pragma Singleton
import QtQuick

QtObject {
    id: theme

    // Palette (Ryoku / Tokyo Night default aesthetic)
    readonly property color bg: "#13141c"
    readonly property color bgSolid: "#13141c"
    readonly property color surface: "#1a1b26"
    readonly property color surfaceSolid: "#24283b"
    readonly property color cardBg: "#1f2335f2"
    readonly property color border: "#24283b"
    readonly property color borderHighlight: "#7aa2f7"

    readonly property color fg: "#c0caf5"
    readonly property color fgMuted: "#565f89"
    readonly property color fgBright: "#ffffff"

    readonly property color accent: "#7aa2f7"
    readonly property color accentMuted: "#3d59a1"
    readonly property color cyan: "#7dcfff"
    readonly property color green: "#9ece6a"
    readonly property color yellow: "#e0af68"
    readonly property color orange: "#ff9e64"
    readonly property color red: "#f7768e"
    readonly property color purple: "#bb9af7"

    // Geometry
    readonly property int barHeight: 38
    readonly property int pillHeight: 36
    readonly property int pillRadius: 18
    readonly property int cardRadius: 14
    readonly property int badgeRadius: 10
    readonly property int spacing: 8
    readonly property int padding: 8

    // Fonts
    readonly property string fontFamily: "Montserrat, Inter, sans-serif"
    readonly property string monoFontFamily: "JetBrainsMono Nerd Font, monospace"
    readonly property int fontSizeSmall: 11
    readonly property int fontSizeNormal: 12
    readonly property int fontSizeLarge: 14
    readonly property int fontSizeTitle: 16

    // Animations
    readonly property int animFast: 150
    readonly property int animNormal: 250
    readonly property int animSlow: 350
    readonly property var easingOut: Easing.OutCubic
}
