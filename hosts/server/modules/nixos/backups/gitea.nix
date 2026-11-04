{ config, pkgs, ... }:
let
  dockerDir = config.services.serverBackup.dockerDir;
  giteaDir = "${dockerDir}/git";
in
{
  # Restoring : https://docs.gitea.com/next/administration/backup-and-restore/#using-docker-restore
  services.serverBackup.services.gitea = {
    paths = [ "${giteaDir}/exports/dump.zip" ];
    preBackup = ''
      set -Eeuo

      cd ${giteaDir}
      # Create dump
      ${pkgs.docker}/bin/docker compose exec -u git -w /tmp -it server bash -c '/usr/local/bin/gitea dump -c /data/gitea/conf/app.ini'

      # Copy dump to host machine in exports directory
      dumpFile=$(${pkgs.docker}/bin/docker compose exec -it server find /tmp -name 'gitea-dump-*')
      ${pkgs.docker}/bin/docker cp $(${pkgs.docker}/bin/docker compose ps -q server):''${dumpFile} "${giteaDir}/exports/dump.zip"
    '';
  };
}
