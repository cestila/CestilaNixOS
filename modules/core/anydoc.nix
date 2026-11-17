{
  lib,
  stdenv,
  fetchurl,
  nodejs,
  makeWrapper,
  autoPatchelfHook,
}: let
  version = "0.2.4";

  src = fetchurl {
    url = "https://registry.npmjs.org/@firecrawl/anydoc/-/anydoc-${version}.tgz";
    hash = "sha512-rfJxa5L+nhoqR5yodcRZoGDLaSfxMTpBuhVj1gSacfW4ZGjBt4cjfErXwaKjPYrpWRTPIBye2sh36UhqgOP1Og==";
  };

  bindingSrc = fetchurl {
    url = "https://registry.npmjs.org/@firecrawl/anydoc-linux-x64-gnu/-/anydoc-linux-x64-gnu-${version}.tgz";
    hash = "sha512-yfvx+iGo2CvZH0TB9MeyNjkrd5/psNFEuxkl2Jah/VNFesPRASqjjCkDRY7tKw7fPij1u/UyFVxI6bsu6Iow9Q==";
  };
in
  stdenv.mkDerivation {
    pname = "anydoc";
    inherit version;

    srcs = [src bindingSrc];
    sourceRoot = ".";

    nativeBuildInputs = [
      makeWrapper
      autoPatchelfHook
    ];

    buildInputs = [
      stdenv.cc.cc.lib
    ];

    unpackPhase = ''
      runHook preUnpack
      mkdir -p anydoc binding
      tar -xzf ${src} -C anydoc --strip-components=1
      tar -xzf ${bindingSrc} -C binding --strip-components=1
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/anydoc $out/bin
      cp -r anydoc/* $out/lib/anydoc/
      cp binding/anydoc.linux-x64-gnu.node $out/lib/anydoc/

      makeWrapper ${nodejs}/bin/node $out/bin/anydoc \
        --add-flags "$out/lib/anydoc/cli.js"

      runHook postInstall
    '';

    meta = with lib; {
      description = "Convert documents to GitHub-Flavored Markdown (Firecrawl)";
      homepage = "https://github.com/firecrawl/anydoc";
      license = licenses.mit;
      platforms = ["x86_64-linux"];
    };
  }
