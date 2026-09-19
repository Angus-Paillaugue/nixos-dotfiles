{ config, ... }: {
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets/ssh.yaml;

    secrets = {
      ssh_private_key.path = "${config.home.homeDirectory}/.ssh/id_ed25519";

      ssh_public_key.path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      borg_password = {
        sopsFile = ../secrets/borg.yaml;
      };
    };
  };
}
