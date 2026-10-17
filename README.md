# Usage

First, install git
```sh
nix-shell -p git
```

Then get the config with :
```sh
git clone https://github.com/Angus-Paillaugue/nixos-dotfiles.git ~/.config/home-manager
cd ~/.config/home-manager
```

Copy the sops secret key to `~/.config/sops/age/keys.txt`

You can now build the config for your host with:
```sh
sudo nixos-rebuild switch --flake .#<your-host> --accept-flake-config
```