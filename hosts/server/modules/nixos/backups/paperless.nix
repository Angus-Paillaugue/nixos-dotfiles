{
  config,
  pkgs,
  lib,
  ...
}:
let
  dockerDir = config.services.serverBackup.dockerDir;
  paperlessDir = lib.escapeShellArg "${dockerDir}/paperless";
in
{
  # Restoring : https://docs.paperless-ngx.com/administration/#exporter
  services.serverBackup.services.paperless = {
    paths = [ "${paperlessDir}/export" ];
    preBackup = ''
      set -Eeuo

      cd ${paperlessDir}
      ${pkgs.docker}/bin/docker compose exec --no-TTY webserver document_exporter /usr/src/paperless/export --zip --no-progress-bar --delete
    '';
  };
}
