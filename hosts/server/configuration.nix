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
    && (builtins.tryEval kernelPackages.nvidiaPackages.production.mod).success
    && (!kernelPackages.nvidiaPackages.production.mod.meta.broken)
    # NVIDIA 595 currently does not build against the development 7.x kernels.
    && (lib.versionOlder kernelPackages.kernel.version "7.0")
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      systemd.network.wait-online.enable = false;
      network.enable = true;
    };
    kernelPackages = latestKernelPackage;
    supportedFilesystems = [ "zfs" ];
    zfs = {
      forceImportRoot = false;
      extraPools = [ "tank" ];
    };
  };

  systemd = {
    network.wait-online.enable = false;
    services = {
      zfs-mount.enable = false;
      suspend.enable = false;
      sleep.enable = false;
      tailscaled.serviceConfig.Environment = [
        "TS_DEBUG_FIREWALL_MODE=nftables"
      ];
    };
  };

  networking = {
    hostId = "5b59d32a";
    hostName = "server";
    networkmanager.enable = true;
    nftables.enable = true;
    firewall = {
      # TODO: Fix this dumb firewall blocking NPM
      enable = false;
      checkReversePath = "loose";
      trustedInterfaces = [
        config.services.tailscale.interfaceName
        "docker0"
      ];
      allowedTCPPorts = [
        53
        80
        443
        853
        5443
      ];
      allowedUDPPorts = [
        config.services.tailscale.port
        53
        443
        784
        853
        8853
        5443
      ];
    };
  };

  # Nvidia
  hardware.graphics.enable = true;
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia-container-toolkit.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";
  
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
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
    tailscale = {
      enable = true;
      useRoutingFeatures = "server";
      extraUpFlags = [
        "--ssh"
        "--advertise-routes=192.168.0.0/24"
        "--advertise-exit-node"
      ];
    };
    xserver = {
      videoDrivers = [ "nvidia" ];
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

  users.users = {
    "angus" = {
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
    "root" = {
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        (builtins.readFile ../../ssh/nixos.pub)
      ];
      extraGroups = ["docker"];
    };
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
    jq
  ];

  programs = {
    fish.enable = true;
    git.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

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
