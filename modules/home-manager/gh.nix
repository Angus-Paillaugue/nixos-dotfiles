{ lib, config, ... }: {
  options = {
    gh.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable gh CLI";
    };
  };

  config = lib.mkIf config.gh.enable {
    programs.gh = {
      enable = true;
      gitCredentialHelper = {
        enable = true;
      };
    };
  };
}
