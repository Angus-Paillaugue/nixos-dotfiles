{
  ...
}:

{
  home.username = "root";
  home.homeDirectory = "/root";
  home.stateVersion = "25.11";

  imports = [
    ../../modules/home-manager
  ];

  # Modules
  fastfetch.enable = true;
  starship.enable = true;

  programs.home-manager.enable = true;
}
