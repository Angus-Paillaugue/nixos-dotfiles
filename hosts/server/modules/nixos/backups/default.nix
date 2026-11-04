{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.serverBackup;
  destination = cfg.destination;
  hookScript =
    phase: name: commands:
    pkgs.writeShellScript "server-backup-${name}-${phase}" ''
      set -Eeuo pipefail
      ${commands}
    '';
  serviceHooks = lib.mapAttrsToList (
    name: service:
    lib.optionalString (service.preBackup != "") (
      let
        script = hookScript "pre" name service.preBackup;
      in
      ''
        echo "Running pre-backup hook for ${lib.escapeShellArg name}"
        ${lib.escapeShellArg script}
      ''
    )
  ) cfg.services;
  serviceCleanupHooks = lib.mapAttrsToList (
    name: service:
    lib.optionalString (service.postBackup != "") (
      let
        script = hookScript "post" name service.postBackup;
      in
      ''
        echo "Running post-backup hook for ${lib.escapeShellArg name}"
        ${lib.escapeShellArg script}
      ''
    )
  ) cfg.services;
  serviceCopies = lib.mapAttrsToList (name: service: ''
    serviceRoot="$backupRoot/${lib.escapeShellArg name}"
    mkdir -p "$serviceRoot"
    echo "Backing up ${lib.escapeShellArg name} to $serviceRoot"
    ${lib.concatMapStringsSep "\n" (path: ''
      if [ ! -e ${lib.escapeShellArg path} ]; then
        echo "Backup path does not exist: ${lib.escapeShellArg path}" >&2
        exit 1
      fi
      ${pkgs.coreutils}/bin/cp -a -- ${lib.escapeShellArg path} "$serviceRoot/"
    '') service.paths}
  '') cfg.services;

  backupScript = pkgs.writeShellScript "server-backup" ''
    set -Eeuo pipefail

    ${lib.concatStringsSep "\n" serviceHooks}

    backupRoot=${lib.escapeShellArg destination}/"$(date +%Y-%m-%d_%H-%M-%S)"
    mkdir -p "$backupRoot"
    echo "Backing up services to '$backupRoot'"

    ${lib.concatStringsSep "\n" serviceCopies}

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
        OnCalendar = "04:00";
        Persistent = true;
        RandomizedDelaySec = "30m";
        Unit = "server-backup.service";
      };
    };
  };
}
