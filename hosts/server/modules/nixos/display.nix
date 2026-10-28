{ lib, ... }: {
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

  greeter.gdm.enable = true;

  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    # lib.mkDefault is required because it can conflict with the cd/dvd ISO building defaults
    displayManager.autoLogin = lib.mkDefault {
      enable = true;
      user = "gaming";
    };
    desktopManager.gnome.enable = true;
    gnome = {
      core-developer-tools.enable = false;
      games.enable = false;
    };
  };
}
