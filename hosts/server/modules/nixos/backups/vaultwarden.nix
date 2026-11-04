{ config, pkgs, ... }:
let
  dockerDir = config.services.serverBackup.dockerDir;
  vaultwardenDir = "${dockerDir}/vaultwarden";
in
{
  # https://github.com/dani-garcia/vaultwarden/wiki/Backing-up-your-vault
  services.serverBackup.services.vaultwarden = {
    paths = [ "${vaultwardenDir}/vaultwarden" ];
    preBackup = ''
      set -Eeuo pipefail

      cd ${vaultwardenDir}
      ${pkgs.docker}/bin/docker compose down
    '';
    postBackup = ''
      set -Eeuo pipefail

      cd ${vaultwardenDir}
      ${pkgs.docker}/bin/docker compose up -d
    '';
  };
}
