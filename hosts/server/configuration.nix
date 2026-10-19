{
  config,
  pkgs,
  lib,
  ...
}:
let
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostId = "5b59d32a";
  boot.kernelPackages = latestKernelPackage;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = [ "tank" ];
  networking.hostName = "server";
  systemd.services.zfs-mount.enable = false;

  # Nvidia
  # hardware.graphics.enable = true;
  # hardware.nvidia.open = true;
  # hardware.nvidia.modesetting.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  services = {
    zfs.autoScrub.enable = true;
    zfs.trim.enable = true;
    openssh = {
      enable = true;
      settings.PermitRootLogin = "yes";
    };
    # openssh = {
    #   enable = true;
    #   settings = {
    #     PermitRootLogin = "prohibit-password";
    #     PasswordAuthentication = false;
    #   };
    # };
    # tailscale.enable = true;
    xserver = {
      # videoDrivers = [ "nvidia" ];
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    qemuGuest.enable = true;
    pulseaudio.enable = false;
    # rtkit.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  users.users."angus" = {
    isNormalUser = true;
    description = "Angus";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      firefox
    ];
  };
  users.users.root = {
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      (builtins.readFile ../../ssh/nixos.pub)
    ];
  };

  environment.systemPackages = with pkgs; [
    borgbackup
    git
    htop
    pciutils
    smartmontools
    zfs
    curl
    wget
  ];

  programs = {
    fish.enable = true;
    git.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  # 1. Enable the service and the firewall
  # networking.nftables.enable = true;
  # networking.firewall = {
  #   enable = true;
  #   # Always allow traffic from your Tailscale network
  #   trustedInterfaces = [ config.services.tailscale.interfaceName ];
  #   # Allow the Tailscale UDP port through the firewall
  #   allowedUDPPorts = [ config.services.tailscale.port ];
  # };

  # # 2. Force tailscaled to use nftables (Critical for clean nftables-only systems)
  # # This avoids the "iptables-compat" translation layer issues.
  # systemd.services.tailscaled.serviceConfig.Environment = [
  #   "TS_DEBUG_FIREWALL_MODE=nftables"
  # ];

  # # 3. Optimization: Prevent systemd from waiting for network online
  # # (Optional but recommended for faster boot with VPNs)
  # systemd.network.wait-online.enable = false;
  # boot.initrd.systemd.network.wait-online.enable = false;

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  system.stateVersion = "26.05";
}
