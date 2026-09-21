{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options = {
    hyprland.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Hyprland";
    };
  };

  config = lib.mkIf config.hyprland.enable {
    home = {
      pointerCursor = {
        gtk.enable = true;
        # x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 16;
      };

      # Trick to expose lua stubs directly
      file.".local/share/hyprland-stubs".source = "${pkgs.hyprland}/share/hypr/stubs";
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      configType = "lua";
      settings = { };

      extraConfig = /* lua */ ''
        ${builtins.readFile ./execs.lua}
        ${builtins.readFile ./general.lua}
        ${builtins.readFile ./keybinds.lua}
        ${builtins.readFile ./rules.lua}
        require("monitors")
        ${if config.noctalia.enable then "require(\"noctalia\").apply_theme()" else ""}
      '';
    };
  };
}
