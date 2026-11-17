{...}: {
  xdg.configFile."hypr/lua/rules.lua".text = ''
    -- Window and Layer rules for Hyprland

    -- Dialog / modal rules
    hl.window_rule({
        name = "ModalFloat",
        match = { modal = true },
        float = true,
        center = true,
    })

    -- XWayland drag fix
    hl.window_rule({
        name = "FixXWaylandDrags",
        match = { class = "^$", title = "^$", xwayland = true, float = true },
        no_focus = true,
    })

    -- Application categories & tags
    local taggedRules = {
        { name = "FileManager", match = { class = "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm|[Pp]cmanfm-qt)$" }, tag = "+file-manager" },
        { name = "Terminals", match = { class = "^(com.mitchellh.ghostty|org.wezfurlong.wezterm|Alacritty|kitty|kitty-dropterm|dropterminal)$" }, tag = "+terminal" },
        { name = "Browsers", match = { class = "^(Brave-browser.*|[Ff]irefox.*|[Gg]oogle-chrome.*|[Tt]horium-browser|[Cc]achy-browser)$" }, tag = "+browser" },
        { name = "Projects", match = { class = "^(VSCode|code-url-handler|codium|VSCodium)$" }, tag = "+projects" },
        { name = "IM", match = { class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop|[Ww]hatsapp-for-linux|teams-for-linux)$" }, tag = "+im" },
        { name = "Telegram", match = { class = "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$" }, tag = "+im", no_initial_focus = true },
        { name = "Games", match = { class = "^(gamescope|steam_app_.*)$" }, tag = "+games" },
        { name = "GameStores", match = { class = "^([Ss]team|com.heroicgameslauncher.hgl)$" }, tag = "+gamestore" },
        { name = "SettingsApps", match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|nm-applet|nm-connection-editor|blueman-manager|nwg-look|qt5ct|qt6ct)$" }, tag = "+settings", float = true, center = true },
    }

    for _, r in ipairs(taggedRules) do
        hl.window_rule(r)
    end

    -- Utility and dialog floating rules
    local floatRules = {
        { name = "PictureInPicture", match = { title = "^(Picture-in-Picture)$" }, float = true, pin = true, keep_aspect_ratio = true },
        { name = "Authentication", match = { title = "^(Authentication Required)$" }, float = true, center = true },
        { name = "WayPaper", match = { class = "^([Ww]aypaper)$" }, float = true },
        { name = "MediaPlayers", match = { class = "^(mpv|com.github.rafostar.Clapper)$" }, float = true },
        { name = "QSKeybinds", match = { title = "^(.*Keybinds.*|.*Cheatsheets.*)$" }, float = true, center = true },
        { name = "HerdrScratchpad", match = { class = "^(ghostty-herdr|herdr-scratchpad)$" }, float = true, center = true, workspace = "special:herdr" },
    }

    for _, r in ipairs(floatRules) do
        hl.window_rule(r)
    end

    -- Layer rules
    local layerRules = {
        { name = "WaybarBlur", match = { namespace = "^waybar$" }, blur = true },
        { name = "CestilaBarBlur", match = { namespace = "^cestila-bar$" }, blur = true },
        { name = "CestilaSidebarBlur", match = { namespace = "^cestila-sidebar$" }, blur = true },
        { name = "DMSBlur", match = { namespace = "^dms:.*$" }, blur = true },
        { name = "SwayncBlur", match = { namespace = "^swaync-control-center$" }, blur = true },
    }

    for _, lr in ipairs(layerRules) do
        hl.layer_rule(lr)
    end
  '';
}
