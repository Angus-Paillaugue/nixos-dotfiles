{ lib, ... }: {
  imports = lib.myLib.listNixRecursively {
    source = ./.;
    omit = [ ./default.nix ];
  };
}
