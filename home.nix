{ pkgs, ... }:

{
  home.username = "angus";
  home.homeDirectory = "/home/angus";
  home.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./modules/hyprland.nix
    ./modules/hyprlock.nix
    ./modules/kitty.nix
    ./modules/code.nix
    ./modules/swww.nix
    ./modules/fish.nix
    ./modules/git.nix
    ./modules/zen.nix
  ];

  home.packages = with pkgs; [
    nil
    nixfmt-rfc-style
    btop
    bibata-cursors
    flat-remix-gtk
    nautilus
    nerd-fonts.jetbrains-mono
    google-fonts
    fnm
    bun
    nwg-displays
  ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    NIXOS_FORCE_FONTCONFIG_DIRS = "1";
  };

  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
