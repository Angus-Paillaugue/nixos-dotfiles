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
    programs.fish = {
      enable = true;
      shellInit = /* fish */ ''
        set fish_greeting;
        ${if config.starship.enable then "${lib.getExe pkgs.starship} init fish | source" else ""}

        function ls
          ${lib.getExe pkgs.eza} --icons --group-directories-first --color=always --classify $argv
        end
        function ll
          ${lib.getExe pkgs.eza} -l --icons --group-directories-first --color=always --git $argv
        end
        function la
          ${lib.getExe pkgs.eza} -la --icons --group-directories-first --color=always --git $argv
        end
        function cat
          ${lib.getExe pkgs.bat} --color always ${if config.noctalia.enable then "--theme=\"noctalia\"" else ""} $argv
        end
      '';
      shellAliases = {
        c = "clear";
        h = "cd ~";
      };
    };
  };
}
