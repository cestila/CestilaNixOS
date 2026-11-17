{
  appimageTools,
  lib,
  fetchurl,
}: let
  pname = "orca-ide";
  version = "1.4.206";

  src = fetchurl {
    url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-linux.AppImage";
    hash = "sha512-z9bUQmACOzJxCe20bWQLCmgbXXFq/NBwh6Lbx3rdiav0rd4tc6YNSlXmCNGx1Q/bcjFTy8zDp1/9KkUQDyGNjQ==";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
  appimageTools.wrapType2 rec {
    inherit pname version src;

    extraInstallCommands = ''
      mkdir -p $out/share/applications $out/share/icons/hicolor/512x512/apps

      # Install desktop file (orca-ide.desktop or orca.desktop)
      if [ -f ${appimageContents}/orca-ide.desktop ]; then
        install -m 444 -D ${appimageContents}/orca-ide.desktop $out/share/applications/orca-ide.desktop
      elif [ -f ${appimageContents}/orca.desktop ]; then
        install -m 444 -D ${appimageContents}/orca.desktop $out/share/applications/orca-ide.desktop
      fi

      if [ -f $out/share/applications/orca-ide.desktop ]; then
        substituteInPlace $out/share/applications/orca-ide.desktop \
          --replace 'Exec=AppRun' 'Exec=orca-ide'
      fi

      # Find and install icons
      for icon in ${appimageContents}/usr/share/icons/hicolor/*/apps/* ${appimageContents}/*.png; do
        if [ -f "$icon" ]; then
          install -m 444 -D "$icon" "$out/share/icons/hicolor/512x512/apps/orca-ide.png"
          break
        fi
      done

      # Provide a symlink to 'orca' in addition to 'orca-ide'
      ln -s orca-ide $out/bin/orca
    '';

    meta = with lib; {
      description = "Orca ADE - Agent Development Environment for managing parallel AI coding agents";
      homepage = "https://onorca.dev";
      license = licenses.mit;
      platforms = ["x86_64-linux"];
      mainProgram = "orca-ide";
    };
  }
