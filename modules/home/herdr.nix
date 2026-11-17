{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  herdrConfig = pkgs.writeText "herdr-config.toml" ''
    # herdr configuration managed by Gentleman.Dots and adapted to Stylix.

    [theme]
    # Use "terminal" base theme so Herdr inherits outer terminal (Ghostty/Stylix) colors
    # and layers Stylix-derived base16 palette tokens on top.
    name = "terminal"

    [theme.custom]
    sidebar_bg = "#${config.lib.stylix.colors.base01}"
    active_row_bg = "#${config.lib.stylix.colors.base02}"
    selection_bg = "#${config.lib.stylix.colors.base03}"
    panel_bg = "#${config.lib.stylix.colors.base00}"
    accent = "#${config.lib.stylix.colors.base0D}"
    red = "#${config.lib.stylix.colors.base08}"
    green = "#${config.lib.stylix.colors.base0B}"
    yellow = "#${config.lib.stylix.colors.base0A}"
    blue = "#${config.lib.stylix.colors.base0D}"

    [ui]
    accent = "#${config.lib.stylix.colors.base0D}"
    pane_gaps = false
    agent_panel_sort = "spaces"

    [ui.sidebar.agents]
    row_gap = 0
    rows = [["state_icon", "workspace", "tab"], ["agent", "terminal_title_stripped"]]

    [keys]
    # Match tmux/Zellij-style prefix muscle memory.
    prefix = "ctrl+a"

    # Move between agents in the sidebar.
    # Avoid Herdr's built-in prefix+shift+j/k pane-swap bindings.
    previous_agent = "prefix+alt+k"
    next_agent = "prefix+alt+j"

    # Jump straight to agent N (1..9) as listed in the sidebar.
    # Use Ctrl after the prefix: Alt+number is owned by skhd/yabai spaces,
    # and Shift+number did not reach Herdr reliably in the current terminal setup.
    focus_agent = "prefix+ctrl+1..9"

    # Herdr Radar plugin keybindings
    [[keys.command]]
    key = "prefix+a"
    type = "plugin_action"
    command = "hhdebb.herdr-radar.view-flip"

    [[keys.command]]
    key = "prefix+comma"
    type = "plugin_action"
    command = "hhdebb.herdr-radar.settings"
  '';
in {
  # Herdr — agent multiplexer that lives in your terminal (https://herdr.dev)

  home.packages = [
    pkgs.herdr
  ];

  home.shellAliases = {
    dev = "herdr";
  };

  # Deploy as a writable, mutable config file seeded with Stylix colors
  # so Herdr's settings UI can freely modify it at runtime.
  home.activation.setupHerdrConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    TARGET="$HOME/.config/herdr/config.toml"
    mkdir -p "$HOME/.config/herdr"

    if [ -L "$TARGET" ]; then
      $DRY_RUN_CMD rm -f "$TARGET"
    fi

    if [ ! -f "$TARGET" ]; then
      $DRY_RUN_CMD cp "${herdrConfig}" "$TARGET"
    else
      # If already exists and is writable, update only if not modified or refresh template
      $DRY_RUN_CMD cp -f "${herdrConfig}" "$TARGET"
    fi
    $DRY_RUN_CMD chmod u+rw "$TARGET"
  '';
}
