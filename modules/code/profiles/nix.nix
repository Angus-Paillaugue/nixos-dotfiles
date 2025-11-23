{ pkgs, ... }:
{
  programs.vscode.profiles.nix = {
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      github.copilot
      github.copilot-chat
    ];
  };
}
