{ config, ... }:
let
  dockerDir = config.services.serverBackup.dockerDir;
  vaultwardenDir = "${dockerDir}/vaultwarden";
in
{
  # https://github.com/dani-garcia/vaultwarden/wiki/Backing-up-your-vault
  services.serverBackup.services.vaultwarden = {
    paths = [ "${vaultwardenDir}/vaultwarden" ];
  };
}
