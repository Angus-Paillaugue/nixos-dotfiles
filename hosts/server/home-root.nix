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

  home.file.".hushlogin".text = "";

  # Modules
  fastfetch.enable = true;
  starship.enable = true;
  gh.enable = true;

  programs.git = {
    enable = true;
    settings.user = {
      name = "Angus-Paillaugue";
      email = "angus@paillaugue.fr";
    };
    settings = {
      init.defaultBranch = "main";
    };
  };

  programs.home-manager.enable = true;
}
