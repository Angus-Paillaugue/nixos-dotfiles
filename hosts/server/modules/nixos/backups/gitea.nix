{
  config,
  pkgs,
  lib,
  ...
}:
let
  dockerDir = config.services.serverBackup.dockerDir;
  giteaDir = lib.escapeShellArg "${dockerDir}/git";
in
{
  # Restoring : https://docs.gitea.com/next/administration/backup-and-restore/#using-docker-restore
  services.serverBackup.services.gitea = {
    paths = [ "${giteaDir}/exports/dump.zip" ];
    preBackup = ''
      set -Eeuo pipefail

      cd ${giteaDir}
      # Create dump
      ${pkgs.docker}/bin/docker compose exec -T -u git -w /tmp server \
        bash -c '/usr/local/bin/gitea dump -c /data/gitea/conf/app.ini'

      # Copy dump to host machine in exports directory
      containerId="$(${pkgs.docker}/bin/docker compose ps -q server)"
      dumpFile="$(${pkgs.docker}/bin/docker compose exec -T server \
        find /tmp -maxdepth 1 -type f -name 'gitea-dump-*' -print -quit)"

      if [ -z "$containerId" ]; then
        echo "Unable to determine the Gitea container ID" >&2
        exit 1
      fi
      if [ -z "$dumpFile" ]; then
        echo "Gitea did not create a dump file" >&2
        exit 1
      fi

      ${pkgs.docker}/bin/docker cp \
        "$containerId:$dumpFile" "${giteaDir}/exports/dump.zip"
    '';
  };
}
