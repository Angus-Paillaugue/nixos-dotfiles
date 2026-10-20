{ lib, ... }: {
  networking.firewall = {
    enable = lib.mkForce false;
    checkReversePath = "loose";
    trustedInterfaces = [
      "docker0"
    ];
    allowedTCPPorts = [
      53
      80
      443
      853
      5443
    ];
    allowedUDPPorts = [
      53
      443
      784
      853
      8853
      5443
    ];
  };
}
