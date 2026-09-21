{ lib, config, inputs, ... }: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options = {
    noctalia.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Noctalia";
    };
  };
  config = lib.mkIf config.noctalia.enable {
    programs.noctalia = {
      enable = true;
      settings = builtins.readFile ./config.toml;
    };
  };
}
