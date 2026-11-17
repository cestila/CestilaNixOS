{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
}:
stdenv.mkDerivation rec {
  pname = "huaweicloud-cli";
  version = "latest";

  src = fetchurl {
    url = "https://hwcloudcli.obs.cn-north-1.myhuaweicloud.com/cli/latest/huaweicloud-cli-linux-amd64.tar.gz";
    hash = "sha256-CwHO4OlDuOwA/nzX3zQfFhZl+BYuroUoD64iGg2fk4s=";
  };

  nativeBuildInputs = [autoPatchelfHook];
  buildInputs = [stdenv.cc.cc.lib];

  sourceRoot = ".";

  unpackPhase = ''
    runHook preUnpack
    tar -xzf $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp hcloud $out/bin/hcloud
    chmod +x $out/bin/hcloud
    runHook postInstall
  '';

  meta = with lib; {
    description = "Huawei Cloud CLI (KooCLI)";
    homepage = "https://support.huaweicloud.com/intl/en-us/koocli/index.html";
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
    mainProgram = "hcloud";
  };
}
