{ lib, ... }:
{
  imports = lib.myLib.listNixRecursively {
    source = ./.;
    omit = [ ./default.nix ];
  };

  options = {
    greeter = {
      gdm.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable gdm greeter";
      };
      noctalia = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable noctalia greeter";
        };
        passwordless-sync-users = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "List of users to sync passwordless login with noctalia greeter";
        };
      };
    };
  };
}
