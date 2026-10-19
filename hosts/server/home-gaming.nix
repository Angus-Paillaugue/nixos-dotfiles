{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  home.username = "gaming";
  home.homeDirectory = "/home/gaming";
  home.stateVersion = "25.11";

  nixpkgs = {
    overlays = [
      inputs.self.overlays.unstable-packages
    ];

    config.allowUnfree = true;
  };

  imports = lib.filter (n: lib.strings.hasSuffix ".nix" n) (
    lib.filesystem.listFilesRecursive ../../modules
  );

  # Modules
  kitty.enable = true;

  home = {
    packages = with pkgs; [
      btop
      prismlauncher
      vlc
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
