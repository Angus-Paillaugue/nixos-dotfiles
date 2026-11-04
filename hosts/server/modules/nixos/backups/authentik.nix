{ config, pkgs, ... }:
let
  dockerDir = config.services.serverBackup.dockerDir;
  authentikDir = "${dockerDir}/authentik";
in
{
  # Restore : https://docs.goauthentik.io/sys-mgmt/ops/backup-restore/#restore
  services.serverBackup.services.authentik = {
    paths = [ "${authentikDir}/export" "${authentikDir}/data" "${authentikDir}/custom-templates" ];
    preBackup = ''
      set -Eeuo

      cd ${authentikDir}
      ${pkgs.docker}/bin/docker exec -i --env-file ./.env $(${pkgs.docker}/bin/docker compose ps -q postgresql) /bin/bash -c 'PGPASSWORD=$POSTGRES_PASSWORD pg_dump --username $POSTGRES_USER $POSTGRES_DB' > ./export/dump.sql 
    '';
  };
}
