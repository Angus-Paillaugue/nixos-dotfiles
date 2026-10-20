{ lib, ... }: {
  imports = lib.filter (n: lib.strings.hasSuffix ".nix" n && n != ./default.nix) (
    lib.filesystem.listFilesRecursive ./.
  );
}
