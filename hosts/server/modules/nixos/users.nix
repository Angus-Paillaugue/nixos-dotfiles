{
  pkgs,
  inputs,
  config,
  ...
}:
{
  users.users = {
    "gaming" = {
      isNormalUser = true;
      description = "Gaming";
      shell = pkgs.fish;
      extraGroups = [
        "networkmanager"
        "wheel"
        "uinput"
      ];
    };
    "root" = {
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        (builtins.readFile ../../../nixos/nixos.pub)
      ];
      extraGroups = [ "docker" ];
    };
    "backups" = {
      isNormalUser = true;
      description = "Backups";
    };
  };
  users.motd = "Welcome to ${config.networking.hostName}!";

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      hostName = config.networking.hostName;
    };
    users."gaming" = import ../../home-gaming.nix;
    users."root" = import ../../home-root.nix;
  };
}
