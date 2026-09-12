{ ... }:

{
  programs.noctalia = {
    enable = true;

    settings = builtins.readFile ./config.toml;
  };
}
