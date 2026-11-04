{ config, ... }:
let
  dockerDir = config.services.serverBackup.dockerDir;
  syncthingDir = "${dockerDir}/syncthing";
in
{
  services.serverBackup.services.syncthing = {
    paths = [ "${syncthingDir}/st-sync" ];
  };
}
