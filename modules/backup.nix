{ pkgs, config, ... }:

let
  mkBackupScript =
    name: service_name: target: to_backup:
    pkgs.writeShellScript "${name}-backup" ''
      script_name="Backup manager"
      to_backup=(
        ${pkgs.lib.concatMapStringsSep "\n\t" pkgs.lib.escapeShellArg to_backup}
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
        Wants = [ "network-online.target" "sops-nix.service" ];
        After = [ "network-online.target" "sops-nix.service" ];
      };
      Service = {
        StandardOutput = "journal";
        StandardError = "journal";
        ExecStart = "${mkBackupScript "nixos" "backup" "root@192.168.0.3:/mnt/storage/backups/nixos" [
          "${config.home.homeDirectory}/Downloads"
          "${config.home.homeDirectory}/Videos"
          "${config.home.homeDirectory}/Documents"
          "${config.home.homeDirectory}/Pictures"
          "${config.home.homeDirectory}/.config/sops/age/keys.txt"
        ]}";
      };
    };
  };
}
