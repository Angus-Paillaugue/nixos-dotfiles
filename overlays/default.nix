{ inputs, ... }: {
  # Make the unstable package set available through pkgs.unstablePkgs.
  nixpkgs.overlays = [
    (final: prev: {
      unstablePkgs = import inputs.nixpkgs-unstable {
        system = final.stdenv.hostPlatform.system;
        config.allowUnfree = true;

        overlays = [
          # TODO: remove when https://github.com/NixOS/nixpkgs/pull/577354 is merged
          (import ./bun.nix)
        ];
      };
    })
  ];
}
