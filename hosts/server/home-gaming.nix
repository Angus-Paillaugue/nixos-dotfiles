{
  pkgs,
  ...
}:

{
  home.username = "gaming";
  home.homeDirectory = "/home/gaming";
  home.stateVersion = "25.11";

  nixpkgs.config.allowUnfree = true;

  imports = [
    ../../modules/home-manager
  ];

  # Modules
  kitty.enable = true;
  starship.enable = true;
  fastfetch.enable = true;

  home.packages = with pkgs; [
    prismlauncher
    vlc
  ];

  programs.home-manager.enable = true;
}
