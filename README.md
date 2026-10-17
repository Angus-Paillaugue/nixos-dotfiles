# Use
```sh
sudo nano /etc/nixos/configuration.nix
```
Add `programs.git.enable = true;` to the configuration file.

Then rebuild your system with:
```sh
sudo nixos-rebuild switch
```

Then get the config with :
```
```sh
git clone https://github.com/Angus-Paillaugue/nixos-dotfiles.git ~/.config/home-manager
cd ~/.config/home-manager
```

You can now build your home-manager configuration with:
```sh
sudo nixos-rebuild switch --flake .#<your-host> --accept-flake-config
```