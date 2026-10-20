{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  options = {
    helium.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Helium browser";
    };
  };

  config = lib.mkIf config.helium.enable {
    home.packages = [
      inputs.helium.packages.${pkgs.system}.default
    ];
  };
}
