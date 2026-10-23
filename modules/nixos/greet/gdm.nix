{ lib, config, ...}: {
  services.displayManager.gdm = lib.mkIf config.greeter.gdm.enable {
    enable = true;
    autoSuspend = false;
  };
}