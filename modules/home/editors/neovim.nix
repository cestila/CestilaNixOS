{pkgs, ...}: {
  home.packages = with pkgs; [
    # Core Editor
    neovim

    # Search & Find (Essential for Telescope/LazyVim)
    ripgrep
    fd

    # Build tools (Essential for Tree-sitter parsers and LSPs)
    gcc
    gnumake
    unzip

    # Runtime for Copilot and LSPs
    nodejs

    # LSPs and Formatters managed natively by NixOS
    lua-language-server
    stylua
    nil # Nix LSP
    alejandra # Nix Formatter

    # Markdown Viewers & Tools
    glow # Visor TUI de Markdown elegante
    mdcat # Visor TUI de Markdown con soporte de imágenes/gráficos en terminales modernos
    mermaid-cli # CLI para renderizar diagramas Mermaid (mmdc)

    # Stack LSPs, Formatters & Debuggers
    phpactor
    pyright
    gopls # Language Server oficial de Go
    delve # Depurador (debugger) oficial de Go para Neovim / DAP
    gotools # Utilidades oficiales de Go (goimports, gorename, etc.)
    golangci-lint # Linter para Go
    typescript-language-server
    vscode-langservers-extracted
    vue-language-server
    terraform-ls
    ansible-language-server
    dockerfile-language-server
    helm-ls
  ];
}
