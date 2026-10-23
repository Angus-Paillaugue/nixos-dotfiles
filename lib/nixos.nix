{ inputs, lib, ... }: {
  mkNixosConfiguration =
    { system, name }:
    inputs.nixpkgs.lib.nixosSystem {
      system = system;
      inherit lib;
      specialArgs = { inherit inputs; };
      modules = [
        ../hosts/${name}/configuration.nix
        inputs.home-manager.nixosModules.default
        (import ../overlays { inherit inputs; })
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          nixpkgs.config.allowUnfree = true;
        }
      ];
    };
}
