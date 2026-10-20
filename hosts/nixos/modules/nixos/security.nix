{
  security = {
    rtkit.enable = true;
    # The daily update runs as a systemd --user service, so sudo must not try
    # to prompt for a password. Keep the passwordless rule limited to the
    # rebuild command; all other sudo commands retain normal authentication.
    sudo.extraRules = [
      {
        users = [ "angus" ];
        commands = [
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
