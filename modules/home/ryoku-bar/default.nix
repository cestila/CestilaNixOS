{
  config,
  lib,
  pkgs,
  ...
}: let
  hasStylix = config ? lib && config.lib ? stylix && config.lib.stylix ? colors;
  stylixColors =
    if hasStylix
    then config.lib.stylix.colors
    else null;
  fontName =
    if config ? stylix && config.stylix ? fonts && config.stylix.fonts ? sansSerif
    then config.stylix.fonts.sansSerif.name
    else "Montserrat";
  monoFontName =
    if config ? stylix && config.stylix ? fonts && config.stylix.fonts ? monospace
    then config.stylix.fonts.monospace.name
    else "JetBrainsMono Nerd Font";

  # The themed directory to link into ~/.config/quickshell/ryoku-bar
  ryokuBarSource =
    if hasStylix
    then
      pkgs.runCommand "ryoku-bar-themed" {} ''
        cp -r ${./.} $out
        chmod -R u+w $out
        cat << 'EOF' > $out/Theme.qml
        pragma Singleton
        import QtQuick

        QtObject {
            id: theme

            // Palette injected from Stylix
            readonly property color bg: "#${stylixColors.base00}"
            readonly property color bgSolid: "#${stylixColors.base00}"
            readonly property color surface: "#${stylixColors.base01}e0"
            readonly property color surfaceSolid: "#${stylixColors.base01}"
            readonly property color cardBg: "#${stylixColors.base01}f2"
            readonly property color border: "#${stylixColors.base02}"
            readonly property color borderHighlight: "#${stylixColors.base0D}"

            readonly property color fg: "#${stylixColors.base05}"
            readonly property color fgMuted: "#${stylixColors.base04}"
            readonly property color fgBright: "#${stylixColors.base06}"

            readonly property color accent: "#${stylixColors.base0D}"
            readonly property color accentMuted: "#${stylixColors.base02}"
            readonly property color cyan: "#${stylixColors.base0C}"
            readonly property color green: "#${stylixColors.base0B}"
            readonly property color yellow: "#${stylixColors.base0A}"
            readonly property color orange: "#${stylixColors.base09}"
            readonly property color red: "#${stylixColors.base08}"
            readonly property color purple: "#${stylixColors.base0E}"

            // Geometry
            readonly property int barHeight: 38
            readonly property int pillHeight: 36
            readonly property int pillRadius: 18
            readonly property int cardRadius: 14
            readonly property int badgeRadius: 10
            readonly property int spacing: 8
            readonly property int padding: 8

            // Fonts
            readonly property string fontFamily: "${fontName}, Inter, sans-serif"
            readonly property string monoFontFamily: "${monoFontName}, monospace"
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
        EOF
      ''
    else ./.;
in {
  xdg.configFile."quickshell/ryoku-bar".source = ryokuBarSource;
}
