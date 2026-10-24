{
  lib,
  config,
  ...
}:
{
  options = {
    nixConfig = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable nix config";
      };
      auto-optimise-store = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable auto-optimise-store for nix";
      };

      gc = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable nix garbage collection";
        };
        dates = lib.mkOption {
          type = with lib.types; either singleLineStr (listOf str);
          default = "weekly";
          description = "Set the dates for nix garbage collection";
        };
        keepDays = lib.mkOption {
          type = lib.types.int;
          default = 7;
          description = "Set the number of days to keep for nix garbage collection";
        };
      };
    };
  };

  config = lib.mkIf config.nix.enable {
    nix = {
      settings = {
        auto-optimise-store = config.nixConfig.auto-optimise-store;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [ "https://noctalia.cachix.org" ];
        trusted-substituters = [ "https://noctalia.cachix.org" ];
        trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
        trusted-users = [
          "root"
          "@wheel"
        ];
      };

      # Garbage collection
      gc = lib.mkIf config.nixConfig.gc.enable {
        automatic = true;
        persistent = true;
        dates = config.nixConfig.gc.dates;
        options = "--delete-older-than ${lib.toString config.nixConfig.gc.keepDays}d";
      };
    };
  };
}
