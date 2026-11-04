{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.serverBackup;
  destination = cfg.destination;
  paths = lib.flatten (lib.mapAttrsToList (_: service: service.paths) cfg.services);
  serviceHooks = lib.mapAttrsToList (
    name: service:
    lib.optionalString (service.preBackup != "") ''
      echo "Running pre-backup hook for ${lib.escapeShellArg name}"
      ${service.preBackup}
    ''
  ) cfg.services;
  serviceCleanupHooks = lib.mapAttrsToList (
    name: service:
    lib.optionalString (service.postBackup != "") ''
      echo "Running post-backup hook for ${lib.escapeShellArg name}"
      ${service.postBackup}
    ''
  ) cfg.services;

  backupScript = pkgs.writeShellScript "server-backup" ''
    set -Eeuo

    ${lib.concatStringsSep "\n" serviceHooks}

    echo "Backing up the following directories to '${destination}' :"
    echo "${lib.concatStringsSep "\n" (lib.map (path: "\t${lib.escapeShellArg path}") paths)}"
    # ${lib.concatMapStringsSep "\n      " lib.escapeShellArg paths}
    # Backup structure :
    # <destination>/<serviceName>/<YYYY-MM-DD-HHMMSS>/<contents of service paths>
    # for path in ${lib.concatStringsSep " " (lib.map lib.escapeShellArg paths)}; do
    #   serviceName=$(basename "''${path}")
    #   timestamp=$(date +%Y-%m-%d-%H%M%S)
    #   backupDir="''${destination}/''${serviceName}/''${timestamp}"
    #   mkdir -p "''${backupDir}"
    #   echo "Backing up ''${path} to ''${backupDir}"
    #   tar -czf "''${backupDir}/backup.tar.gz" -C "''${path}" .
    # done

    ${lib.concatStringsSep "\n" serviceCleanupHooks}
  '';
in
{
  imports = lib.myLib.listNix {
    source = ./.;
    omit = [ ./default.nix ];
  };

  options.services.serverBackup = {
    enable = lib.mkEnableOption "Backups for Docker service data";

    dockerDir = lib.mkOption {
      type = lib.types.str;
      description = "Directory containing Docker Compose projects and service data.";
      example = "/srv/docker";
    };

    paths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [  ];
      description = "Paths included in the backup.";
    };

    destination = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The destination directory for the backup archive. This must be a local path.";
    };

    services = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            paths = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "Additional paths belonging to this service.";
            };
            preBackup = lib.mkOption {
              type = lib.types.lines;
              default = "";
              description = "Shell commands run while containers are still running.";
            };
            postBackup = lib.mkOption {
              type = lib.types.lines;
              default = "";
              description = "Shell commands run after the archive and container restart.";
            };
          };
        }
      );
      default = { };
      description = "Service-specific paths and export/cleanup hooks.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.destination != null;
        message = "services.serverBackup.destination must be set when services.serverBackup.enable is true.";
      }
      # {
      #   assertion = lib.all (path: lib.pathExists path) paths;
      #   message = "All paths in services.serverBackup.paths must exist.";
      # }
    ];

    systemd.services.server-backup = {
      description = "Back up Docker service data to a directory";
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
      ];
      path = [
        pkgs.coreutils
        pkgs.findutils
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = backupScript;
      };
    };

    systemd.timers.server-backup = {
      description = "Daily Docker service backup";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "03:30";
        Persistent = true;
        RandomizedDelaySec = "30m";
        Unit = "server-backup.service";
      };
    };
  };
}
