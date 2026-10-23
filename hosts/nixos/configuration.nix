{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    ./modules/nixos
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;

      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
      ];
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  programs = {
    hyprland = {
      enable = true;
      package = pkgs.unstablePkgs.hyprland;
      portalPackage = pkgs.unstablePkgs.xdg-desktop-portal-hyprland;
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
      ];
    };
    fish.enable = true;
    git = {
      enable = true;
      config.safe.directory = [ "/home/angus/.config/home-manager" ];
    };
  };

  greeter.noctalia = {
    enable = true;
    passwordless-sync-users = [ "angus" ];
  };

  system.stateVersion = "25.11";
}
