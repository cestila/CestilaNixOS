{
  description = "CestilaNixOS";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:danth/stylix/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/7a0cfabbca29286f67ae545b4b309ad996dd76dc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Checking nixvim to see if it's better
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Google Antigravity (IDE)
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    synfetch = {
      url = "github:SXSLVT/synfetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
      url = "github:ogulcancelik/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    alejandra = {
      url = "github:kamadorueda/alejandra";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    serpantinum = {
      url = "github:ilyamiro/serpantinum";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dux-shell = {
      url = "github:duxlabs-dev/dux-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cestila-shell = {
      url = "github:cestila/cestila-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    conduit = {
      url = "github:cestila/ConduitOmniChat";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils"; # Flake utilities
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixvim,
    nix-flatpak,
    alejandra,
    flake-utils,
    serpantinum,
    dux-shell,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "cestila";

    mkNixosSystem = {
      host,
      profile,
      extraModules ? [],
      user ? username,
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs host profile;
          username = user;
        };
        modules =
          [
            ./modules/core/overlays.nix
            ./profiles/${profile}
            nix-flatpak.nixosModules.nix-flatpak
            serpantinum.nixosModules.default
          ]
          ++ extraModules;
      };

    mkNixosConfig = host: profile:
      mkNixosSystem {
        inherit host profile;
      };
  in {
    lib = {
      inherit mkNixosSystem;
    };

    nixosConfigurations = {
      cestila-note = mkNixosConfig "cestila-note" "intel";
      amd = mkNixosConfig "default" "amd";
      nvidia = mkNixosConfig "default" "nvidia";
      nvidia-laptop = mkNixosConfig "default" "nvidia-laptop";
      amd-nvidia-hybrid = mkNixosConfig "default" "amd-nvidia-hybrid";
      intel = mkNixosConfig "default" "intel";
      vm = mkNixosConfig "cestilanixos-24-vm" "vm";
      oem = mkNixosConfig "cestilanixos-oem" "intel";
    };

    formatter.x86_64-linux = inputs.alejandra.packages.x86_64-linux.default;
  };
}
