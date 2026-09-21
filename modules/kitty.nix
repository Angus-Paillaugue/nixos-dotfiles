{ lib, config, ... }: {
  options = {
    kitty.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Kitty terminal emulator";
    };
  };

  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;

      settings = {
        font_family = "JetBrainsMono Nerd Font";
        font_size = 11.0;
        cursor_shape = "beam";
        cursor_trail = 1;
        window_margin_width = 21.75;
        confirm_os_window_close = 0;
        shell = "fish";
        background_opacity = 0.8;
        enable_audio_bell = "no";
        allow_hyperlinks = "yes";
        include = lib.mkIf config.noctalia.enable "${config.home.homeDirectory}/.config/kitty/themes/noctalia.conf";
      };
    };
  };
}
