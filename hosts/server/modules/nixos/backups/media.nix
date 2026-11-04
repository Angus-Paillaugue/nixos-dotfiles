{ config, ... }:
let
  dockerDir = config.services.serverBackup.dockerDir;
  mediaDir = "${dockerDir}/media";
in
{
  services.serverBackup.services.media = {
    paths = [
      "${mediaDir}/Jellyfin"
      "${mediaDir}/ntfy"
    ];
  };
}
