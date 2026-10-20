{ pkgs, ... }: {
  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs = {
      forceImportRoot = false;
      extraPools = [ "tank" ];
    };
  };

  systemd.services.zfs-mount.enable = false;

  services = {
    zfs = {
      autoScrub = {
        enable = true;
        interval = "weekly";
      };
      trim = {
        enable = true;
        interval = "weekly";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    pciutils
    smartmontools
    zfs
  ];
}
