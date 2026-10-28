{ lib, inputs }:
let
  hostNames = builtins.attrNames (import ./hosts.nix { inherit lib; });
  isoModules = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];
in
lib.listToAttrs (
  map (hostName: {
    name = "${hostName}-iso";
    value = lib.myLib.mkNixosConfiguration {
      system = "x86_64-linux";
      name = hostName;
      extraModules = isoModules;
    };
  }) hostNames
)
