{ config, ... }:
let
  dockerDir = config.services.serverBackup.dockerDir;
  syncthingsDir = "${dockerDir}/syncthings";
in
{
  services.serverBackup.services.syncthings = {
    paths = [ "${syncthingsDir}/st-sync" ];
  };
}
