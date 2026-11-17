{host, vars, ...}: let
  inherit
    (vars)
    alacrittyEnable
    barChoice
    ghosttyEnable
    tmuxEnable
    waybarChoice
    weztermEnable
    vscodeEnable
    helixEnable
    doomEmacsEnable
    antigravityEnable
    zedEnable
    ;
  hyprlandEnable = vars.hyprlandEnable or true;
  herdrEnable = vars.herdrEnable or false;
  homestudioEnable = vars.homestudioEnable or vars.homeStudioEnable or false;
  devTuiEnable = vars.devTuiEnable or vars.devTUIEnable or false;
  devGuiEnable = vars.devGuiEnable or vars.devGUIEnable or false;
  devopsTuiEnable = vars.devopsTuiEnable or vars.devopsTUIEnable or false;
  devopsGuiEnable = vars.devopsGuiEnable or vars.devopsGUIEnable or false;
  conduitEnable = vars.conduitEnable or false;
  kittyEnable = vars.kittyEnable or (vars.terminal == "kitty");

  # Select bar module based on barChoice (used when hyprland is enabled)
  barModule =
    if hyprlandEnable && (barChoice == "dux-shell" || barChoice == "dux" || barChoice == "dms")
    then ./dux-shell.nix
    else if hyprlandEnable && barChoice == "serpantinum"
    then ./serpantinum.nix
    else if hyprlandEnable && (barChoice == "cestila-shell" || barChoice == "cestila")
    then ./cestila-shell.nix
    else if hyprlandEnable && barChoice == "noctalia"
    then ./noctalia.nix
    else if hyprlandEnable && barChoice == "ryoku"
    then ./ryoku-bar
    else waybarChoice;
in {
  imports =
    [
      ./gtk.nix

      ./starship.nix
      ./zellij.nix
      ./bash.nix
      ./bashrc-personal.nix
      ./python.nix
      ./cli/bat.nix
      ./cli/btop.nix
      ./cli/bottom.nix
      ./cli/cava.nix
      ./emoji.nix
      ./eza.nix
      ./fastfetch
      ./cli/fzf.nix
      ./cli/gh.nix
      ./cli/glab.nix
      ./cli/hcloud.nix
      ./cli/git.nix
      ./cli/htop.nix
      ./cli/lazygit.nix
      #./obs-studio.nix
      ./editors/nano.nix
      ./editors/neovim.nix
      ./qt.nix
      ./scripts
      #./scripts/gemini-cli.nix
      ./stylix.nix
      ./tealdeer.nix
      ./virtmanager.nix
      ./xdg.nix
      ./yazi
      #./zen-browser.nix
      ./zoxide.nix
      ./direnv.nix
      ./zsh
    ]
    ++ (
      if homestudioEnable
      then [./homestudio.nix]
      else []
    )
    ++ (
      if devTuiEnable
      then [./dev-tui.nix]
      else []
    )
    ++ (
      if devGuiEnable
      then [./dev-gui.nix]
      else []
    )
    ++ (
      if devopsTuiEnable
      then [./cli/devops-tui.nix]
      else []
    )
    ++ (
      if devopsGuiEnable
      then [./cli/devops-gui.nix]
      else []
    )
    ++ (
      if conduitEnable
      then [./conduit.nix]
      else []
    )
    ++ (
      if herdrEnable
      then [./herdr.nix]
      else []
    )
    ++ (
      if hyprlandEnable
      then [
        ./hyprland
        barModule
        ./overview.nix
        ./rofi
        ./swappy.nix
        ./swaync.nix
        ./wlogout
      ]
      else []
    )
    ++ (
      if helixEnable
      then [./editors/evil-helix.nix]
      else []
    )
    ++ (
      if vscodeEnable
      then [./editors/vscode.nix]
      else []
    )
    ++ (
      if antigravityEnable
      then [./editors/antigravity.nix]
      else []
    )
    ++ (
      if doomEmacsEnable
      then [
        ./editors/doom-emacs-install.nix
        ./editors/doom-emacs.nix
      ]
      else []
    )
    ++ (
      if zedEnable
      then [./editors/zed.nix]
      else []
    )
    ++ (
      if weztermEnable
      then [./terminals/wezterm.nix]
      else []
    )
    ++ (
      if ghosttyEnable
      then [./terminals/ghostty.nix]
      else []
    )
    ++ (
      if tmuxEnable
      then [./terminals/tmux.nix]
      else []
    )
    ++ (
      if alacrittyEnable
      then [./terminals/alacritty.nix]
      else []
    )
    ++ (
      if kittyEnable
      then [./terminals/kitty.nix]
      else []
    );
}
