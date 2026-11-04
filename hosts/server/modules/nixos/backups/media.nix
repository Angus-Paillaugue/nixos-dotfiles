{ config, ... }:
let
  dockerDir = config.services.serverBackup.dockerDir;
  mediaDir = "${dockerDir}/media";
in
{
  services.serverBackup.services.media = {
    paths = [
      "${mediaDir}/Jellyfin/bazarr-config/backup"
      "${mediaDir}/Jellyfin/jackett-config"
      "${mediaDir}/Jellyfin/jellyfin-config"
      "${mediaDir}/Jellyfin/prowlarr-config/Backups"
      "${mediaDir}/Jellyfin/radarr-config/Backups"
      "${mediaDir}/Jellyfin/sonarr-config/Backups"
      
      "${mediaDir}/ntfy"
    ];
  };
}
