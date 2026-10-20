{
  # DO NOT SLEEP
  systemd = {
    sleep.settings.Sleep = {
      AllowSuspend = false;
      AllowHibernation = false;
      AllowSuspendThenHibernate = false;
      AllowHybridSleep = false;
    };
    services = {
      suspend.enable = false;
      sleep.enable = false;
    };
  };

  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    displayManager = {
      gdm = {
        enable = true;
        autoSuspend = false;
      };
      autoLogin = {
        enable = true;
        user = "gaming";
      };
    };
    desktopManager.gnome.enable = true;
    gnome = {
      core-developer-tools.enable = false;
      games.enable = false;
    };
  };
}
