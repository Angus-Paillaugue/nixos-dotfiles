{ pkgs, lib, ... }:

{
  home.username = "angus";
  home.homeDirectory = "/home/angus";
  home.stateVersion = "25.11";
  nixpkgs.config.allowUnfree = true;

  imports = lib.filter (n: lib.strings.hasSuffix ".nix" n) (
    lib.filesystem.listFilesRecursive ../../modules
  );

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
    nerd-fonts.jetbrains-mono
    nixd
    openssl
    sops
    age
    ssh-to-age
    eog
    xar
    qemu
    quickemu
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
}
