{ lib, config, ... }: {
  options = {
    obsidian.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Obsidian";
    };
  };

  config = lib.mkIf config.obsidian.enable {
    programs.obsidian = {
      enable = true;
      vaults = {
        "Personal" = {
          enable = true;
          target = "Documents/Obsidian/Personal";
        };
      };
    };
  };
}
