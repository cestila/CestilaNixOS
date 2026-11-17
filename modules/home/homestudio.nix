{
  pkgs,
  lib,
  host,
  vars, ...
}: let
  homestudioWindowsVstEnable =
    vars.homestudioWindowsVstEnable
    or vars.homestudioWindowsVSTEnable
    or vars.homestudioWinVstEnable
    or false;

  # Script de ayuda para configurar Vulkan, DXVK, fuentes y runtimes en ~/.wine-homestudio
  setupWineScript = pkgs.writeShellScriptBin "homestudio-setup-wine" ''
    set -euo pipefail
    export WINEPREFIX="''${WINEPREFIX:-$HOME/.wine-homestudio}"
    export WINEDEBUG="-all"
    export WINEFSYNC=1
    export WINEESYNC=1

    echo "==> Inicializando prefix Wine Home Studio en $WINEPREFIX..."
    mkdir -p "$WINEPREFIX"
    ${pkgs.wineWow64Packages.staging}/bin/wineboot -u

    echo "==> Configurando Vulkan, DXVK y dependencias gráficas para GUIs de VSTs..."
    ${pkgs.winetricks}/bin/winetricks -q dxvk vkd3d corefonts gdiplus vcredist2015 vcredist2019 vcredist2022 || true

    echo "==> Sincronizando Yabridge..."
    ${pkgs.yabridgectl}/bin/yabridgectl sync || true

    echo "==> ¡Configuración gráfica y de Wine Home Studio lista!"
  '';

  windowsVstPackages =
    if homestudioWindowsVstEnable
    then [
      # Compatibilidad con plugins de Windows (Wine Staging + DXVK/Vulkan + Yabridge)
      pkgs.wineWow64Packages.staging # Wine Staging optimizado con soporte 32/64 bits
      pkgs.winetricks # Instalador de librerías para Windows
      pkgs.yabridge # Puente VST2/VST3/CLAP sobre Wine
      pkgs.yabridgectl # CLI de administración y sincronización de plugins yabridge
      pkgs.dxvk # Capa Direct3D 9/10/11 sobre Vulkan para renderizado de GUIs de VSTs
      pkgs.vulkan-tools # Herramientas de diagnóstico de Vulkan (vkcube, vulkaninfo)
      setupWineScript # Comando 'homestudio-setup-wine'
    ]
    else [];

  windowsVstSessionVars =
    if homestudioWindowsVstEnable
    then {
      WINEPREFIX = "$HOME/.wine-homestudio"; # Prefix de Wine aislado para plugins y audio
      WINEDEBUG = "-all"; # Desactiva logs ruidosos para garantizar tiempo real sin caídas
      WINEFSYNC = "1"; # Sincronización rápida basada en fsync
      WINEESYNC = "1"; # Fallback a eventfd sync (esync)
      STAGING_AUDIO_DURATION = "10000"; # Buffer de audio optimizado en Wine Staging
    }
    else {};
in {
  # REAPER se instala desde Nix. Sus extensiones, scripts y plugins (ReaPack,
  # ReaAssist, SWS, ReaImGui, JSFX) se gestionan directamente con ReaPack dentro de REAPER.
  home.packages =
    (with pkgs; [
      # DAW
      reaper

      # Enrutamiento, control y patchbays de PipeWire / JACK
      qpwgraph # Patchbay gráfico de PipeWire
      easyeffects # Efectos y ecualización de sistema / micrófono

      # Procesamiento, mezcla y masterización (VST / LV2)
      lsp-plugins # Linux Studio Plugins (ecualizadores, dinámicas, analizadores)
      calf # Calf Studio Gear (suite de mezcla)
      x42-plugins # Plugins de utilidad, balance y medición
      distrho-ports # Colección portada de sintes y efectos
      dragonfly-reverb # Suite de reverberación (Hall, Room, Plate)
      neural-amp-modeler-lv2 # NAM: Modelado de amplificadores de guitarra/bajo por IA
      guitarix # Procesador de guitarra / efectos
      chow-tape-model # Emulación analógica de cinta
      zam-plugins # Compresores, limitadores y procesadores para mastering
      airwindows-lv2 # Algoritmos de mezcla y DSP de Airwindows
    ])
    ++ windowsVstPackages;

  # Variables de entorno dedicadas para el Home Studio y Wine
  home.sessionVariables = windowsVstSessionVars;

  # Inicialización de directorios de plugins y configuración de Yabridgectl (si Windows VST está activo)
  home.activation.seedHomeStudioConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p "$HOME/.vst3"
    $DRY_RUN_CMD mkdir -p "$HOME/.vst"
    $DRY_RUN_CMD mkdir -p "$HOME/.clap"
    $DRY_RUN_CMD mkdir -p "$HOME/.lv2"

    ${
      if homestudioWindowsVstEnable
      then ''
        $DRY_RUN_CMD mkdir -p "$HOME/.config/yabridgectl"
        $DRY_RUN_CMD mkdir -p "$HOME/.wine-homestudio/drive_c/Program Files/Common Files/VST3"
        $DRY_RUN_CMD mkdir -p "$HOME/.wine-homestudio/drive_c/Program Files/Common Files/VST2"
        $DRY_RUN_CMD mkdir -p "$HOME/.wine-homestudio/drive_c/Program Files/Vstplugins"
        $DRY_RUN_CMD mkdir -p "$HOME/.wine-homestudio/drive_c/Program Files (x86)/Common Files/VST3"
        $DRY_RUN_CMD mkdir -p "$HOME/.wine-homestudio/drive_c/Program Files (x86)/Vstplugins"

        if [ ! -f "$HOME/.config/yabridgectl/config.toml" ]; then
          $DRY_RUN_CMD printf 'plugin_dirs = [\n    \x27%s/.wine-homestudio/drive_c/Program Files/Common Files/VST3\x27,\n    \x27%s/.wine-homestudio/drive_c/Program Files/Common Files/VST2\x27,\n    \x27%s/.wine-homestudio/drive_c/Program Files/Vstplugins\x27,\n    \x27%s/.wine-homestudio/drive_c/Program Files (x86)/Common Files/VST3\x27,\n    \x27%s/.wine-homestudio/drive_c/Program Files (x86)/Vstplugins\x27,\n]\nvst2_location = \x27centralized\x27\nno_verify = false\nblacklist = []\n' "$HOME" "$HOME" "$HOME" "$HOME" "$HOME" > "$HOME/.config/yabridgectl/config.toml"
        fi
      ''
      else ""
    }
  '';
}
