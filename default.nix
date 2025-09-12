{
  self ? import ./nix/utils/import-flake.nix {
    src = ./.;
  },
  inputs ? self.inputs,
  system ? builtins.currentSystem,
  pkgs ? import inputs.nixpkgs {
    config = { };
    overlays = [ ];
    inherit system;
  },
  lib ? import "${inputs.nixpkgs}/lib",
}:
let
  args = {
    inherit
      lib
      pkgs
      self
      system
      inputs
      ;
    inherit (default)
      format
      packages
      go
      ;
    devLib = default.legacyPackages.lib;
    devShells = default.shells;
  };

  default = rec {
    format = import ./nix/formatter.nix args;
    go = import ./nix/go.nix args;

    legacyPackages.lib = pkgs.callPackage ./nix/lib.nix { };
    packages = { };
    shells = go.shells or { };

    inherit flake;
  };

  flake = {
    inherit (default) legacyPackages;
    inherit (default.format) formatter;
    devShells = default.shells;
    packages = lib.filterAttrs (n: v: lib.isDerivation v) default.packages;
  };
in
default // args
