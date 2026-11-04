{ config, ... }:
let
  dockerDir = config.services.serverBackup.dockerDir;
  obsidianDir = "${dockerDir}/obsidian";
in
{
  services.serverBackup.services.obsidian = {
    paths = [ "${obsidianDir}/douchdb-data" ];
  };
}
