{ pkgs, ... }:

{
  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;
    colorScheme = "dark";

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };
  # Trick to expose lua stubs directly
  home.file.".local/share/hyprland-stubs".source = "${pkgs.hyprland}/share/hypr/stubs";

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    settings = { };
    extraConfig = /* lua */ ''
      ${builtins.readFile ./execs.lua}
      ${builtins.readFile ./general.lua}
      ${builtins.readFile ./keybinds.lua}
      ${builtins.readFile ./rules.lua}
      require("monitors")
    '';
  };
}
