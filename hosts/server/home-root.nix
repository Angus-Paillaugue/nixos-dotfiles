{
  lib,
  ...
}:

{
  home.username = "root";
  home.homeDirectory = "/root";
  home.stateVersion = "25.11";

  imports = lib.filter (n: lib.strings.hasSuffix ".nix" n) (
    lib.filesystem.listFilesRecursive ../../modules
  );

  # Modules
  fastfetch.enable = true;
  starship.enable = true;

  programs.home-manager.enable = true;
}
