{
  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;

    xserver = {
      enable = true;
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # Enable the GNOME Desktop Environment.
    desktopManager.gnome.enable = true;
    # Enable CUPS to print documents.
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    # Enable sound with pipewire.
    pulseaudio.enable = false;

    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
  };
}
