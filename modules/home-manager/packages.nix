{ pkgs, ... }: {
  home.packages = with pkgs; [
    nixd
    nixfmt
    btop
    nautilus
    nerd-fonts.jetbrains-mono
    jq
    vlc
    curl
    wget
    tree
    gnumake
    openssl
    sops
    age
    ssh-to-age
    xar
    less
    gnupg
    lsof
  ];
}
