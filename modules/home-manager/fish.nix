{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.fish = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable fish";
    };
  };

  config = lib.mkIf config.fish.enable {
    home.packages =
      with pkgs;
      [
        eza
        bat
      ]
      ++ lib.optional config.starship.enable pkgs.starship;

    programs.fish = {
      enable = true;
      interactiveShellInit = /* fish */ ''
        set fish_greeting;
        ${if config.starship.enable then "starship init fish | source" else ""}
        alias create-shell="~/.config/home-manager/utils/create-shell.sh $argv"
        alias c="clear"
        alias h="cd ~"
        alias ls="eza --icons --group-directories-first --color=always --classify"
        alias ll="eza -l --icons --group-directories-first --color=always --git"
        alias la="eza -la --icons --group-directories-first --color=always --git"
        alias cat="bat --color always --theme gruvbox-dark"
      '';
    };
  };
}
