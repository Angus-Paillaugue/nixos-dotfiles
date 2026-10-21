{
  home.file.".ssh/id_ed25519.pub".source = ../../nixos.pub;

  programs = {
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "Host server" = {
          HostName = "192.168.0.3";
          User = "root";
          IdentityFile = "~/.ssh/id_ed25519";
        };
      };
    };
  };
}
