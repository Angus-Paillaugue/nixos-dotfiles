{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.systemd.network.wait-online.enable = false;
    zfs = {
      extraPools = [ "tank" ];
      forceImportRoot = false;
    };
  };

  networking = {
    hostName = "server";
    hostId = "5b59d32a";
    networkmanager.enable = true;
    nftables.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [
        config.services.tailscale.interfaceName
        "docker0"
      ];
      allowedTCPPorts = [
        22
        80
        443
      ];
      allowedUDPPorts = [
        config.services.tailscale.port
      ];
      checkReversePath = "loose";
    };
  };

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };
  };

  environment.systemPackages = with pkgs; [
    borgbackup
    git
    htop
    pciutils
    smartmontools
    zfs
  ];

  programs = {
    fish.enable = true;
    git.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
      };
    };
    tailscale.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    qemuGuest.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  users.users.gaming = {
    isNormalUser = true;
    description = "Gaming";
    extraGroups = [
      "audio"
      "video"
      "networkmanager"
    ];
  };
  users.users.root.openssh.authorizedKeys.keys = [
    (builtins.readFile ../../ssh/nixos.pub)
  ];

  systemd = {
    services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];
    network.wait-online.enable = false;
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

  system.stateVersion = "25.11";
}
