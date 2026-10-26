{ lib, ... }: {
  nixos = lib.myLib.mkNixosConfiguration {
    system = "x86_64-linux";
    name = "nixos";
  };

  server = lib.myLib.mkNixosConfiguration {
    system = "x86_64-linux";
    name = "server";
  };
}
