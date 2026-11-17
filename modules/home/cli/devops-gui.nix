{pkgs, ...}: let
  dbeaver-wrapped = pkgs.symlinkJoin {
    name = "dbeaver-wrapped";
    paths = [pkgs.dbeaver-bin];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/dbeaver \
        --set GDK_BACKEND x11
    '';
  };
in {
  imports = [
    ./devops-base.nix
  ];

  home.packages = [
    # Herramientas visuales y de escritorio para DevOps & Sysadmin
    dbeaver-wrapped # Entorno visual universal para bases de datos (PostgreSQL, MySQL, Oracle, SQLite, etc.)
    pkgs.bruno # Cliente API REST / GraphQL rápido, offline y basado en archivos Git (alternativa a Postman)
    pkgs.remmina # Cliente de escritorios remotos, RDP, SSH y VNC
    pkgs.anydesk # Software de escritorio remoto y asistencia remota
  ];
}
