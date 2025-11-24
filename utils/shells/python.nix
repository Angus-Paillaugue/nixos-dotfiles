{ pkgs ? import <nixpkgs> {} }:

let
  pythonEnv = pkgs.{python_pkg}.withPackages (
    ps: with ps; [
      numpy
    ]
  );
in
pkgs.mkShell {
  buildInputs = [
    pythonEnv
  ];

  shellHook = ''
    if [ ! -d .venv ]; then
      echo "Creating virtual environment (.venv)…"
      python -m venv .venv
    fi
    source .venv/bin/activate
  '';
}
