{ inputs, lib, ... }:
let
  libraryFiles = lib.filter (file: file != ./default.nix && lib.hasSuffix ".nix" (toString file)) (
    lib.filesystem.listFilesRecursive ./.
  );

  listNixRecursively =
    {
      source,
      omit ? [ ],
    }:
    lib.filter (
      file:
      let
        path = toString file;
      in
      lib.hasSuffix ".nix" path && !(builtins.any (excluded: path == toString excluded) omit)
    ) (lib.filesystem.listFilesRecursive source);

  # Like the above function but not recursive, only lists .nix files in the given directory.
  listNix =
    {
      source,
      omit ? [ ],
    }:
    lib.filter (
      file:
      let
        path = toString file;
      in
      lib.hasSuffix ".nix" path && !(builtins.any (excluded: path == toString excluded) omit)
    ) (lib.mapAttrsToList (name: _: source + "/${name}") (builtins.readDir source));
in
{
  inherit listNixRecursively listNix;
}
// builtins.foldl' (functions: file: functions // import file { inherit inputs lib; }) { } libraryFiles
