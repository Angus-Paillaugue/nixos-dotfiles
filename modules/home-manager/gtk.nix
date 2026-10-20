{ pkgs, ... }:
{
  gtk = {
    enable = true;
    colorScheme = "dark";

    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };

    gtk4.theme = null;
  };
}
