{ config, ... }: {
  sops.secrets = {
    private_key = {
      sopsFile = ../../../../secrets/nixos_ssh.yaml;
      path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    };

    borg_password.sopsFile = ../../../../secrets/borg.yaml;
  };
}
