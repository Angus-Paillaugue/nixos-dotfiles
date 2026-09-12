{ pkgs, lib, ... }:

{
  home.username = "angus";
  home.homeDirectory = "/home/angus";
  home.stateVersion = "25.11";
  nixpkgs.config.allowUnfree = true;

  imports = lib.filter (n: lib.strings.hasSuffix ".nix" n) (
    lib.filesystem.listFilesRecursive ./modules
  );

  home.packages = with pkgs; [
    nil
    nixfmt
    btop
    bibata-cursors
    flat-remix-gtk
    nautilus
    nerd-fonts.jetbrains-mono
    google-fonts
    fnm
    bun
    nwg-displays
    jq
    libreoffice
    prismlauncher
    remmina
    vlc
    curl
    wget
    tree
    bat
    gnumake
    eza
    bat
    go-task
    bun
    moonlight-qt
    nwg-displays
    inkscape
    virt-manager
    nerd-fonts.jetbrains-mono
  ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    NIXOS_FORCE_FONTCONFIG_DIRS = "1";
  };

  fonts.fontconfig.enable = true;

  # nixGL.vulkan.enable = true;
  targets.genericLinux.nixGL.vulkan.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
