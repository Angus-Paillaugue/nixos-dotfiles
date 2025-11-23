{ ... }:
let
  profiles = ["nix" "svelte"];
in{
  imports = (map (p: ./profiles/${p}.nix) profiles)
    ++ [ (import ./settings.nix { inherit profiles; }) ];
  programs.vscode = {
    enable = true;
  };
}