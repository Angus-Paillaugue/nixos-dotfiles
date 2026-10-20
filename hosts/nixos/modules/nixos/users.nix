{
  pkgs,
  inputs,
  config,
  ...
}:
{
  users.users.angus = {
    isNormalUser = true;
    description = "Angus";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "libvirtd"
    ];
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      hostName = config.networking.hostName;
    };
    users."angus" = import ../../home.nix;
  };
}
