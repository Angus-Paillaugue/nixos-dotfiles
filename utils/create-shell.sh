#!/usr/bin/env bash

type="$1"
shift
other_args="$@"
here=$(pwd)
script_location="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
shell_location="$here/shell.nix"

function write_shell(){
  # $1 contents
  echo "$1" > "$shell_location"
}

function set_up_java_shell() {
  local java_version="$1"
  if [[ -z "$java_version" ]]; then
    java_version="21"
  fi

  CONTENTS=$(cat "$script_location/shells/java.nix" | sed "s/{java_version}/$java_version/g")
  write_shell "$CONTENTS"

  echo "Created python shell.nix using: java${java_version}"
}

function set_up_python_shell() {
  local python_version="$1"

  # Default if no version specified
  if [[ -z "$python_version" ]]; then
    python_pkg="python3"
  else
    python_pkg="python${python_version/./}"
  fi

  CONTENTS=$(cat "$script_location/shells/python.nix" | sed "s/{python_pkg}/$python_pkg/g")
  write_shell "$CONTENTS"

  echo "Created python shell.nix using: ${python_pkg}"
}

case $type in
  "python" | "py" )
    set_up_python_shell $other_args
    ;;
  "java" )
    set_up_java_shell $other_args
    ;;
  * )
    echo "Unavailable shell"
    exit 1
    ;;
esac
