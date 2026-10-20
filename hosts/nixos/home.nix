{
  config,
  hostName,
  inputs,
  ...
}:

{
  home.username = "angus";
  home.homeDirectory = "/home/angus";
  home.stateVersion = "25.11";

  imports = [
    ../../modules/home-manager
    ./modules/home-manager
  ];

  # Modules
  zen.enable = true;
  zed.enable = true;
  kitty.enable = true;
  gh.enable = true;
  noctalia.enable = true;
  hyprland.enable = true;
  update.enable = true;
  syncthing.enable = true;
  direnv.enable = true;
  starship.enable = true;
  fastfetch.enable = true;
  helium.enable = true;
  backup = {
    enable = true;
    target = "root@192.168.0.3:/mnt/storage/backups/${hostName}";
    toBackup = [
      "${config.home.homeDirectory}/Downloads"
      "${config.home.homeDirectory}/Videos"
      "${config.home.homeDirectory}/Documents"
      "${config.home.homeDirectory}/Pictures"
      "${config.home.homeDirectory}/Music"
      "${config.home.homeDirectory}/.config/sops/age/keys.txt"
    ];
  };

  home = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      NIXOS_FORCE_FONTCONFIG_DIRS = "1";
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  fonts.fontconfig.enable = true;

  targets.genericLinux.nixGL.vulkan.enable = true;

  nixpkgs = {
    overlays = [
      inputs.self.overlays.unstable-packages
    ];

    config.allowUnfree = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
