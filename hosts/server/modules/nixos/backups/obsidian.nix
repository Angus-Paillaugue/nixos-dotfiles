{ config, pkgs, ... }:
let
  dockerDir = config.services.serverBackup.dockerDir;
  obsidianDir = "${dockerDir}/obsidian";
in
{
  services.serverBackup.services.obsidian = {
    paths = [ "${obsidianDir}/couchdb-data" ];
    preBackup = ''
      set -Eeuo pipefail

      cd ${obsidianDir}
      ${pkgs.docker}/bin/docker compose down
    '';
    postBackup = ''
      set -Eeuo pipefail

      cd ${obsidianDir}
      ${pkgs.docker}/bin/docker compose up -d
    '';
  };
}
