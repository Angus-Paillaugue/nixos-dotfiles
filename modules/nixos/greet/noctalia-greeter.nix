{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.greeter.noctalia;
in
{
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  services.displayManager.noctalia-greeter = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 24;
        path = pkgs.bibata-cursors;
      };
    };
    passwordless-sync-users = cfg.passwordless-sync-users;
  };
}
