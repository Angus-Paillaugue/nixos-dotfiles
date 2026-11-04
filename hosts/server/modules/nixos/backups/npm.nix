{ config, ... }:
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
  };
}
