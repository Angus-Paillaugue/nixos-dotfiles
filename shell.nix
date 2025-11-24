{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    openjdk21
    maven
    gradle
  ];

  shellHook = ''
    echo "Welcome to java 21 !"
  '';
}
