{ config, ... }:
let
  dockerDir = config.services.serverBackup.dockerDir;
  radicaleDir = "${dockerDir}/radicale";
in
{
  services.serverBackup.services.radicale = {
    paths = [
      "${radicaleDir}/data"
      "${radicaleDir}/cfg"
    ];
  };
}
