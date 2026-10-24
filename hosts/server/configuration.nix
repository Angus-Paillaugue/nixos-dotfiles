{
  pkgs,
  ...
}:
let
  # TODO: Fix the hard pinned kernel version
  # This is here because ZFS and Nvidia do not know how to behave...
  latestKernelPackage = pkgs.linuxKernel.packages.linux_6_18;
in
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
    initrd.network.enable = true;
    kernelPackages = latestKernelPackage;
  };

  networking = {
    hostId = "5b59d32a";
    hostName = "server";
    networkmanager.enable = true;
  };

  services = {
    tailscale = {
      useRoutingFeatures = "server";
      extraUpFlags = [
        "--ssh"
        "--advertise-routes=192.168.0.0/24"
        "--advertise-exit-node"
      ];
    };
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    borgbackup
    git
    htop
    curl
    wget
    jq
    btop
  ];

  programs = {
    fish.enable = true;
    git.enable = true;
    nix-ld.enable = true;
  };

  # Nix garbage collection keeps 14 days old generations instead of 7, just because I can
  nixConfig.gc.keepDays = 14;

  # Enable docker nvidia support
  dockerModule.with-nvidia = true;

  system.stateVersion = "26.05";
}
