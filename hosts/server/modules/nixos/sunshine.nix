{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    settings = {
      system_tray = "disabled";
      csrf_allowed_origins = "https://sunshine.home.paillaugue.fr";
      encoder = "vulkan";
    };
  };
}
