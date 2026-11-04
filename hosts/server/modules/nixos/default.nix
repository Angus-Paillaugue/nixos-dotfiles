{ lib, ... }: {
  imports =
    lib.myLib.listNix {
      source = ./.;
      omit = [ ./default.nix ];
    }
    ++ [ ./backups/default.nix ];
}
