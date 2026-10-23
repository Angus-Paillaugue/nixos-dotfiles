{ inputs, ... }:
let
  config = {
    projectRootFile = "flake.nix";
    programs.nixfmt = {
      enable = true;
      indent = 2;
      width = 120;
    };
    programs.stylua = {
      enable = true;
      settings = {
        column_width = 120;
        indent_type = "Spaces";
        indent_width = 2;
      };
    };
    programs.toml-sort = {
      enable = true;
      all = true;
    };
  };

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  eachSystem = f: inputs.nixpkgs.lib.genAttrs systems (system: f inputs.nixpkgs.legacyPackages.${system});
  treefmtEval = eachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs config);

  formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

  checks = eachSystem (pkgs: {
    formatting = treefmtEval.${pkgs.system}.config.build.check inputs.self;
  });
in
{
  inherit formatter checks;
}
