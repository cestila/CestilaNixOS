{
  appimageTools,
  lib,
  fetchurl,
}: let
  pname = "openpencil";
  version = "0.7.5";

  src = fetchurl {
    url = "https://github.com/ZSeven-W/openpencil/releases/download/v${version}/OpenPencil-${version}-x86_64-linux.AppImage";
    sha256 = "0pks73k2x9xrb56iiwm4qr29i4vw734b3mn4sk58ibh1mf36hjww";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
  appimageTools.wrapType2 rec {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/openpencil.desktop $out/share/applications/openpencil.desktop
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/1024x1024/apps/openpencil.png $out/share/icons/hicolor/1024x1024/apps/openpencil.png
      substituteInPlace $out/share/applications/openpencil.desktop \
        --replace 'Exec=AppRun' 'Exec=openpencil'
    '';

    meta = with lib; {
      description = "The world's first open-source AI-native vector design tool";
      homepage = "https://github.com/ZSeven-W/openpencil";
      license = licenses.mit;
      platforms = ["x86_64-linux"];
    };
  }
