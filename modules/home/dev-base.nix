{pkgs, ...}: {
  # Herramientas fundamentales de desarrollo (comunes para modo TUI y GUI)
  home.packages = with pkgs; [
    # Runtimes & Gestores de paquetes
    go # Lenguaje de programación Go
    nodejs # Runtime de Node.js
    python3 # Intérprete Python 3
    uv # Gestor de paquetes y proyectos Python ultra rápido (Rust)

    # Control de versiones y Forjas
    git # Control de versiones
    lazygit # Interfaz TUI para Git
    gh # GitHub CLI oficial
    glab # GitLab CLI oficial
    tea # Gitea CLI oficial
    delta # Pager con resaltado sintáctico para diffs de Git

    # Contenedores (Podman) y PaaS
    podman # Motor de contenedores rootless
    podman-compose # Orquestación compose para Podman
    lazydocker # Interfaz TUI para gestión de contenedores Docker/Podman
    (writeShellScriptBin "dokploy" ''
      exec ${nodejs}/bin/npx --yes @dokploy/cli "$@"
    '') # Dokploy CLI oficial para gestión de servidores y despliegues

    # Bases de datos y clientes SQL (TUI e interactivos)
    postgresql # Cliente oficial de PostgreSQL (psql)
    mariadb.client # Cliente oficial de MySQL / MariaDB (mysql)
    usql # Cliente universal para SQL con autocompletado (Postgres, MySQL, SQLite, etc.)
    pgcli # CLI enriquecida para PostgreSQL con sintaxis y autocompletado inteligente
    mycli # CLI enriquecida para MySQL con sintaxis y autocompletado inteligente
    harlequin # IDE / visor visual de bases de datos TUI para terminal

    # Herramientas esenciales y utilidades de productividad
    jq # Procesador JSON en línea de comandos
    yq-go # Procesador YAML/XML/CSV
    ripgrep # Búsqueda de texto ultra rápida
    fd # Alternativa rápida a 'find'
    fzf # Buscador difuso interactivo
    bat # Visor de archivos con resaltado sintáctico
    eza # Alternativa moderna a 'ls'
    tokei # Estadísticas de código y conteo de líneas
    tree-sitter # Motor de parseo para editores
    snyk # Escáner de seguridad y vulnerabilidades en dependencias y código
    anydoc # Conversor de documentos (.docx, .pdf, etc.) a Markdown para LLMs (Firecrawl)
    direnv # Entornos por directorio
    nix-direnv # Integración rápida de direnv con Nix
  ];

  # PATH para binarios globales instalados vía npm y go en el Home del usuario
  home.sessionPath = [
    "$HOME/.npm-global/bin"
    "$HOME/go/bin"
  ];
}
