{ pkgs, ... }: {
  home.packages = with pkgs; [
    google-fonts
    nwg-displays
    libreoffice
    prismlauncher
    remmina
    pkgs.unstablePkgs.bun
    moonlight-qt
    nwg-look
    inkscape
    virt-manager
    eog
    qemu
    quickemu
    vorta
    yt-dlp
    beekeeper-studio
    opentofu
    hyprpicker
    bruno
  ];
}
