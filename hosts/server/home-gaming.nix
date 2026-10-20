{
  pkgs,
  inputs,
  ...
}:

{
  home.username = "gaming";
  home.homeDirectory = "/home/gaming";
  home.stateVersion = "25.11";

  nixpkgs = {
    overlays = [
      inputs.self.overlays.unstable-packages
    ];

    config.allowUnfree = true;
  };

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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
