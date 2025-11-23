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
    ./modules/code/code.nix
    ./modules/swww.nix
  ];

  programs.zen-browser = {
    enable = true;
    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
  };

  home.packages = with pkgs; [
    firefox
    nil
    nixfmt-rfc-style
    nerd-fonts.jetbrains-mono
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting;
    '';
  };
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    NIXOS_FORCE_FONTCONFIG_DIRS = "1";
  };
  programs.git = {
    enable = true;
    settings ={
      user = {
        name = "Angus-Paillaugue";
        email = "angus.paillaugue40@gmail.com";
      };
    };
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
