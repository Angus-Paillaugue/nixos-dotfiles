{ config, pkgs, ... }:
let
  dockerDir = config.services.serverBackup.dockerDir;
  radicaleDir = "${dockerDir}/radicale";
in
{
  services.serverBackup.services.radicale = {
    paths = [
      "${radicaleDir}/data"
      "${radicaleDir}/cfg"
    ];
    preBackup = ''
      set -Eeuo pipefail

      cd ${radicaleDir}
      ${pkgs.docker}/bin/docker compose down
    '';
    postBackup = ''
      set -Eeuo pipefail

      cd ${radicaleDir}
      ${pkgs.docker}/bin/docker compose up -d
    '';
  };
}
