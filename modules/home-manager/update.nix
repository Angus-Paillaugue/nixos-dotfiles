{
  lib,
  config,
  pkgs,
  ...
}:

let
  mkUpdateScript =
    user: config_dir:
    pkgs.writeShellScript "update-script" ''
      set -euo pipefail
      script_name="System update"
      log_file="$(mktemp -t update-XXXXXX.log)"

      function log() {
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >> "$log_file"
      }

      function notify() {
        ${pkgs.libnotify}/bin/notify-send --app-name="$script_name" "$*"
      }

      on_exit() {
        status=$?
        trap - EXIT

        if (( status != 0 )); then
          resp=$(notify -u critical "System update failed (exit status $status)" -A "See logs")
          if [ "$resp" = "0" ]; then
            ${pkgs.kitty}/bin/kitty --hold bash -c "bat -l log $log_file"
          fi
        fi

        exit "$status"
      }
      trap on_exit EXIT

      cd "${config_dir}" || exit 1
      log "Starting system update..."
      notify "Starting system update..."
      log "Running update task..."
      ./task update > "$log_file" 2>&1

      if [ -n "$(${pkgs.git}/bin/git status --porcelain)" ]; then
        log "Committing update to git..."
        ${pkgs.git}/bin/git commit -am "chore: Update ($(date +%Y/%m/%d-%H:%M:%S))" > "$log_file" 2>&1
        log "Pushing update to remote..."
        ${pkgs.git}/bin/git push origin main > "$log_file" 2>&1
      else
        log "No changes to commit."
      fi
      log "System update finished successfully."
      notify "Finished system update"
    '';
in
{
  options.update = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable auto updates";
    };
    configLocation = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/.config/home-manager";
      description = "Location of the home-manager configuration directory";
    };
  };

  config = lib.mkIf config.update.enable {
    home.packages = with pkgs; [
      libnotify
      git
      kitty
      bat
    ];

    systemd.user = {
      timers."update" = {
        Install.WantedBy = [ "timers.target" ];
        Unit = {
          Description = "Timer for update service";
        };
        Timer = {
          Unit = "update.service";
          OnCalendar = "daily";
          Persistent = true;
          RandomizedDelaySec = "15m";
        };
      };

      services."update" = {
        Unit = {
          Description = "Daily update script";
          Wants = [ "network-online.target" ];
          After = [ "network-online.target" ];
        };
        Service = {
          Type = "oneshot";
          StandardOutput = "journal";
          StandardError = "journal";
          Environment = [
            "PATH=/run/wrappers/bin:${config.home.profileDirectory}/bin:/run/current-system/sw/bin:/usr/bin"
          ];
          ExecStart = "${mkUpdateScript config.home.username config.update.configLocation}";
        };
      };
    };
  };
}
