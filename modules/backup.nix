{
  pkgs,
  lib,
  config,
  hostName,
  ...
}:
let
  mkBackupScript =
    name: service_name: target: toBackup:
    pkgs.writeShellScript "${name}-backup" ''
      script_name="Backup manager"
      to_backup=(
        ${pkgs.lib.concatMapStringsSep "\n\t" pkgs.lib.escapeShellArg toBackup}
      )
      compression="zstd,1"
      commonExcludes=(
        ".cache"
        "*/cache2"
        "*/Cache"
        ".npm/_cacache"
        "node_modules"
        "*/node_modules"
        "build"
        "*/build"
        ".venv"
        "*/.venv"
      )
      export BORG_PASSPHRASE="$(cat "${config.sops.secrets.borg_password.path}")"

      ${pkgs.libnotify}/bin/notify-send -a "$script_name" "Starting backup of ${name}..."

      ${pkgs.borgbackup}/bin/borg create \
        --progress \
        --stats \
        --compression $compression \
        --exclude-caches \
        --exclude-from <(printf "%s\n" "''${commonExcludes[@]}") \
        "${target}::$(date +%Y-%m-%d_%H-%M-%S)" \
        "''${to_backup[@]}"

      return_code=$?
      # If 0 or 1, the backup was successful or had warnings. If other, it failed.
      if [ $return_code -eq 0 ] || [ $return_code -eq 1 ]; then
        ${pkgs.libnotify}/bin/notify-send -a "$script_name" "\"${name}\" backup completed successfully."
      else
        choice=$(${pkgs.libnotify}/bin/notify-send -a "$script_name" "\"${name}\" backup failed. Check the logs for details." -A "View Logs")
        if [ "$choice" = "0" ]; then
          ${pkgs.kitty}/bin/kitty --hold bash -c "journalctl -xb --user-unit=${service_name} -n 50 --no-pager | bat -l log"
        fi
      fi
    '';
in
{
  options.backup = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable backup service";
    };
    target = lib.mkOption {
      type = lib.types.str;
      description = "Target for backup";
      example = "backup@host:/path/to/backup";
      default = "backup@host:/path/to/backup";
    };
    toBackup = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of paths to backup";
      example = [
        "/home/user/Documents"
        "/home/user/Pictures"
      ];
      default = [ ];
    };
  };

  config = lib.mkIf config.backup.enable {
    systemd.user = {
      timers."backup" = {
        Install.WantedBy = [ "timers.target" ];
        Unit = {
          Description = "Timer for backup service";
          After = [ "sops-nix.service" ];
          Wants = [ "sops-nix.service" ];
        };
        Timer = {
          Unit = "backup.service";
          OnCalendar = "daily";
          Persistent = true;
          RandomizedDelaySec = "15m";
        };
      };

      services."backup" = {
        Unit = {
          Description = "Daily Backup Script";
          Wants = [
            "network-online.target"
            "sops-nix.service"
          ]
          ++ (if config.update.enable then [ "update.service" ] else [ ]);
          After = [
            "network-online.target"
            "sops-nix.service"
          ]
          ++ (if config.update.enable then [ "update.service" ] else [ ]);
        };
        Service = {
          Type = "oneshot";
          StandardOutput = "journal";
          StandardError = "journal";
          ExecStart = mkBackupScript hostName "backup" config.backup.target config.backup.toBackup;
        };
      };
    };
  };
}
