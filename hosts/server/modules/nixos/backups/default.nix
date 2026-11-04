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
  pathChecks = lib.concatMapStringsSep "\n" (path: ''
    if [ ! -e ${lib.escapeShellArg path} ]; then
      echo "Backup path does not exist: ${lib.escapeShellArg path}" >&2
      exit 1
    fi
  '') paths;

  backupScript = pkgs.writeShellScript "server-backup" ''
    set -Eeuo pipefail

    ${lib.concatStringsSep "\n" serviceHooks}

    repository=${lib.escapeShellArg destination}
    if [ ! -d "$repository" ]; then
      echo "Borg repository does not exist: $repository" >&2
      exit 1
    fi

    ${pathChecks}
    ${pkgs.borgbackup}/bin/borg create \
      --lock-wait 600 \
      --compression zstd,3 \
      --exclude-caches \
      "$repository::backup-$(date +%Y-%m-%d_%H-%M-%S)" \
      ${lib.concatMapStringsSep " " lib.escapeShellArg paths}

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
      description = "The local Borg repository receiving the backup archives.";
    };

    retention = {
      daily = lib.mkOption {
        type = lib.types.ints.positive;
        default = 7;
      };
      weekly = lib.mkOption {
        type = lib.types.ints.positive;
        default = 4;
      };
      monthly = lib.mkOption {
        type = lib.types.ints.positive;
        default = 2;
      };
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
      description = "Back up Docker service data to Borg";
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
      ];
      path = [
        pkgs.borgbackup
        pkgs.coreutils
        pkgs.findutils
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = backupScript;
      };
    };

    systemd.services.server-backup-prune = {
      description = "Prune old Docker service Borg archives";
      after = [ "server-backup.service" ];
      requires = [ "server-backup.service" ];
      path = [ pkgs.borgbackup ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "server-backup-prune" ''
          set -Eeuo pipefail
          repository=${lib.escapeShellArg destination}
          ${pkgs.borgbackup}/bin/borg prune \
            --list \
            --lock-wait 600 \
            --glob-archives 'backup-*' \
            --keep-daily ${toString cfg.retention.daily} \
            --keep-weekly ${toString cfg.retention.weekly} \
            --keep-monthly ${toString cfg.retention.monthly} \
            "$repository"
          ${pkgs.borgbackup}/bin/borg compact --lock-wait 600 "$repository"
        '';
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

    systemd.timers.server-backup-prune = {
      description = "Weekly Borg backup retention";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "Sun 05:00";
        Persistent = true;
        Unit = "server-backup-prune.service";
      };
    };
  };
}
