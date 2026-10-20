{ pkgs, ... }: {
  environment = {
    pathsToLink = [
      "/share/hypr"
    ];
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
    systemPackages = with pkgs; [
      qemu
      borgbackup
      dnsmasq
    ];
  };
}
