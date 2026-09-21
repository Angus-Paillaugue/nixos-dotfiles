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

      on_exit() {
        status=$?
        trap - EXIT

        if (( status != 0 )); then
          resp=$(${pkgs.libnotify}/bin/notify-send \
            -u critical \
            -a "$script_name" \
            "System update failed (exit status $status)" \
            -A "See logs")
          if [ "$resp" = "0" ]; then
            ${pkgs.kitty}/bin/kitty --hold bash -c "journalctl -xb --user-unit=update.service -n 50 --no-pager | bat -l log"
          fi
        fi

        exit "$status"
      }
      trap on_exit EXIT

      echo "conf=${config_dir}"
      echo "user=${user}"
      cd "${config_dir}" || exit 1
      ${pkgs.libnotify}/bin/notify-send -a "$script_name" "Starting system update..."
      ${pkgs.go-task}/bin/task switch
      # Commit update to git and push to remote
      ${pkgs.git}/bin/git commit -am "chore: Update ($(date +%Y/%m/%d-%H:%M:%S))"
      ${pkgs.git}/bin/git push origin main
      ${pkgs.libnotify}/bin/notify-send -a "$script_name" "Finished system update"
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
