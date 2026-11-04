{ config, ... }:
let
  dockerDir = config.services.serverBackup.dockerDir;
  immichDir = "${dockerDir}/immich";
in
{
  # Restoring : https://docs.immich.app/administration/backup-and-restore/#restoring-a-database-backup
  services.serverBackup.services.immich = {
    paths = [ "${immichDir}/immich/library" ];
  };
}
