{ pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
    package = pkgs.fastfetchMinimal;

    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      logo = {
        type = "small";
      };
      display = {
        separator = "  ";
        color = {
          keys = "blue";
        };
        size = {
          ndigits = 0;
          maxPrefix = "GB";
        };
      };
      modules = [
        {
          type = "os";
          key = "╭─";
          format = "{3}";
        }
        {
          type = "shell";
          key = "├─";
        }
        {
          type = "cpu";
          key = "├─󰍛";
          format = "{1}";
        }
        {
          type = "disk";
          key = "├─";
          format = "{1} / {2} ({3})";
          percent = {
            green = 70;
            yellow = 85;
          };
        }
        {
          type = "packages";
          key = "├─󰏗";
          format = "{1} packages";
        }
        {
          type = "uptime";
          key = "╰─󰄉";
        }
      ];
    };
  };
}
