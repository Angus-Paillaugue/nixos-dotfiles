{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    openjdk{java_version}
    maven
    gradle
  ];

  shellHook = ''
    echo "Welcome to java {java_version} !"
  '';
}
