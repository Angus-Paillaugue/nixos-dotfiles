{ config, pkgs, ... }:
let
  dockerDir = config.services.serverBackup.dockerDir;
  npmDir = "${dockerDir}/reverse-proxy";
in
{
  services.serverBackup.services.npm = {
    paths = [
      "${npmDir}/data"
      "${npmDir}/letsencrypt"
    ];
    preBackup = ''
      set -Eeuo pipefail

      cd ${npmDir}
      ${pkgs.docker}/bin/docker compose down
    '';
    postBackup = ''
      set -Eeuo pipefail

      cd ${npmDir}
      ${pkgs.docker}/bin/docker compose up -d
    '';
  };
}
