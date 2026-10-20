{
  lib,
  config,
  ...
}:
{
  options = {
    dockerModule = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable docker";
      };
      with-nvidia = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable docker with nvidia support";
      };
    };
  };

  config = lib.mkIf config.dockerModule.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      daemon.settings.features.cdi = config.dockerModule.with-nvidia;
    };
    hardware.nvidia-container-toolkit.enable = config.dockerModule.with-nvidia;
  };
}
