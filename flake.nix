{
  description = "My Nix Config";

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    hyprland.url = "github:hyprwm/Hyprland";
    noctalia.url = "github:noctalia-dev/noctalia";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      zen-browser,
      noctalia,
      hyprland,
      sops-nix,
      ...
    }:
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./hosts/nixos/configuration.nix
          ];
        };
      };

      homeConfigurations = {
        angus = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          modules = [
            ./hosts/nixos/home.nix
            zen-browser.homeModules.beta
            noctalia.homeModules.default
            sops-nix.homeManagerModules.sops
            {
              wayland.windowManager.hyprland = {
                enable = true;
                package =
                  hyprland.packages.${nixpkgs.legacyPackages.x86_64-linux.stdenv.hostPlatform.system}.hyprland;
                portalPackage =
                  hyprland.packages.${nixpkgs.legacyPackages.x86_64-linux.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
              };
            }
          ];
        };
      };
    };
}
