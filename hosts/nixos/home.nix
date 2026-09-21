{ pkgs, lib, config, hostName, ... }:

{
  home.username = "angus";
  home.homeDirectory = "/home/angus";
  home.stateVersion = "25.11";
  nixpkgs.config.allowUnfree = true;

  imports = lib.filter (n: lib.strings.hasSuffix ".nix" n) (
    lib.filesystem.listFilesRecursive ../../modules
  );

  # Modules
  zen.enable = true;
  zed.enable = true;
  kitty.enable = true;
  gh.enable = true;
  noctalia.enable = true;
  hyprland.enable = true;
  update.enable = true;
  backup = {
    enable = true;
    target = "root@192.168.0.3:/mnt/storage/backups/${hostName}";
    toBackup = [
      "${config.home.homeDirectory}/Downloads"
      "${config.home.homeDirectory}/Videos"
      "${config.home.homeDirectory}/Documents"
      "${config.home.homeDirectory}/Pictures"
      "${config.home.homeDirectory}/.config/sops/age/keys.txt"
    ];
  };

  home.packages = with pkgs; [
    nil
    nixfmt
    btop
    bibata-cursors
    adw-gtk3
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
    nwg-look
    inkscape
    virt-manager
    nixd
    openssl
    sops
    age
    ssh-to-age
    eog
    xar
    qemu
    quickemu
    libnotify
    vorta
    less
    yt-dlp
  ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    NIXOS_FORCE_FONTCONFIG_DIRS = "1";
  };

  programs = {
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "Host server" = {
          HostName = "192.168.0.3";
          User = "root";
          IdentityFile = "~/.ssh/id_ed25519";
        };
      };
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  fonts.fontconfig.enable = true;

  targets.genericLinux.nixGL.vulkan.enable = true;

  programs.git = {
    enable = true;
    settings.user = {
      name = "Angus-Paillaugue";
      email = "angus@paillaugue.fr";
    };
  };

  sops.secrets = {
    ssh_private_key = {
      sopsFile = ../../secrets/ssh.yaml;
      path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    };

    ssh_public_key = {
      sopsFile = ../../secrets/ssh.yaml;
      path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
    };

    borg_password.sopsFile = ../../secrets/borg.yaml;
  };
}
