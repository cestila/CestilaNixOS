{
  inputs,
  host,
  vars, ...
}: let
  # Import the host-specific variables.nix
in {
  imports =
    [
      ./boot.nix
      ./flatpak.nix
      ./fonts.nix
      ./hardware.nix
      ./network.nix
      ./nfs.nix
      ./nh.nix
      ./packages.nix
      ./printing.nix
      # Conditionally import the display manager module
      (
        if vars.displayManager == "tui"
        then ./ly.nix
        else ./sddm.nix
      )
      ./security.nix
      ./services.nix
      ./steam.nix
      ./stylix.nix
      ./syncthing.nix
      ./system.nix
      ./pcmanfm.nix
      ./user.nix
      ./virtualisation.nix
      ./xserver.nix
      ./cachix.nix
      ./cosmic.nix
      inputs.stylix.nixosModules.stylix
    ]
    ++ (
      if (vars.hyprlandEnable or true) && ((vars.barChoice or "") == "noctalia" || (vars.barChoice or "") == "ryoku" || (vars.barChoice or "") == "cestila-shell" || (vars.barChoice or "") == "cestila" || (vars.barChoice or "") == "serpantinum" || (vars.barChoice or "") == "dux-shell" || (vars.barChoice or "") == "dux" || (vars.barChoice or "") == "dms")
      then [./quickshell.nix]
      else []
    )
    ++ (
      if (vars.homestudioEnable or vars.homeStudioEnable or false)
      then [./homestudio.nix]
      else []
    );

  programs.serpantinum.enable = (vars.hyprlandEnable or true) && ((vars.barChoice or "") == "serpantinum");
}
