home-manager:
	home-manager switch --flake ~/.config/home-manager#angus

nixos:
	sudo nixos-rebuild switch --flake /etc/nixos#nixos

# Cleanup
cleanup: cleanup-store cleanup-garbage
cleanup-store:
	sudo nix-store --optimise
cleanup-garbage:
	sudo nix-collect-garbage -d
