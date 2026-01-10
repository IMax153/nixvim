{ inputs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs {
        inherit (prev) system;
        config.allowUnfree = true;
      };
    })
  ];
}
