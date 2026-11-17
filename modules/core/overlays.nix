{inputs, ...}: {
  nixpkgs.overlays = [
    # Provide pkgs.google-antigravity via antigravity-nix overlay
    inputs.antigravity-nix.overlays.default
    (_final: prev: {
      openpencil = prev.callPackage ./openpencil.nix {};
      orca-ide = prev.callPackage ./orca-ide.nix {};
      anydoc = prev.callPackage ./anydoc.nix {};
      huaweicloud-cli = prev.callPackage ./huaweicloud-cli.nix {};
      anydesk = let
        anydeskBase = prev.anydesk.overrideAttrs (old: {
          src = old.src.overrideAttrs (_: {
            outputHash = "sha256-zS5P2eyTHZY7cBW8mQ2Q6M0lXcx9VZZTtpG3Bb6u7IQ=";
          });
        });
      in
        prev.symlinkJoin {
          name = "anydesk";
          paths = [anydeskBase];
          buildInputs = [prev.makeWrapper];
          postBuild = ''
            wrapProgram $out/bin/anydesk \
              --set GDK_PIXBUF_MODULE_FILE "${prev.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
              --set GDK_BACKEND x11
          '';
        };
      reaper = prev.symlinkJoin {
        name = "reaper";
        paths = [prev.reaper];
        nativeBuildInputs = [prev.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/reaper \
            --set GDK_BACKEND x11 \
            --prefix LD_LIBRARY_PATH : ${prev.lib.makeLibraryPath [prev.gtk3 prev.libepoxy]}
        '';
      };
      # Workaround for nixpkgs #576406 / PR #575861:
      # Linux 7.3 System.map causes out-of-tree v4l2loopback modules_install to run depmod,
      # conflicting with kernel modules in aggregateModules. Passing DEPMOD=true fixes it.
      linuxKernel = prev.linuxKernel // {
        packagesFor = kernel: (prev.linuxKernel.packagesFor kernel).extend (_kfinal: kprev: {
          v4l2loopback = kprev.v4l2loopback.overrideAttrs (old: {
            preBuild = "";
            installFlags = (old.installFlags or []) ++ [
              "DEPMOD=true"
              "INSTALL_MOD_PATH=${placeholder "out"}"
            ];
          });
        });
      };
    })
  ];
}
