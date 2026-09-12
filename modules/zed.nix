{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zed-editor
  ];

  programs.zed-editor = {
    enable = true;
  };
}
