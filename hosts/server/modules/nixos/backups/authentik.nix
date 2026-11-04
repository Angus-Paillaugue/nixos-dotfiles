{ config, pkgs, ... }:
let
  dockerDir = config.services.serverBackup.dockerDir;
  authentikDir = "${dockerDir}/authentik";
in
{
  # Restore : https://docs.goauthentik.io/sys-mgmt/ops/backup-restore/#restore
  services.serverBackup.services.authentik = {
    paths = [
      "${authentikDir}/export"
      "${authentikDir}/data"
      "${authentikDir}/custom-templates"
    ];
    preBackup = ''
      set -Eeuo pipefail

      cd ${authentikDir}
      postgresContainer="$(${pkgs.docker}/bin/docker compose ps -q postgresql)"
      if [ -z "$postgresContainer" ]; then
        echo "Unable to determine the Authentik PostgreSQL container ID" >&2
        exit 1
      fi

      ${pkgs.docker}/bin/docker compose exec -T postgresql \
        sh -c 'pg_dump --username "$POSTGRES_USER" "$POSTGRES_DB"' > ./export/dump.sql
    '';
  };
}
