{
  lib,
  inputs,
  default,
  ...
}:
let
  flake-utils = inputs.flake-utils.lib;

  flattenFlakeAttrs =
    attrs:
    lib.pipe attrs [
      (flake-utils.flattenTree)
      (lib.filterAttrs (_: v: lib.isDerivation v && !v.meta.broken or false))
    ];

  flake.perSystem = {
    formatter = default.formatter.package;

    devShells = default.devShells;
    packages = flattenFlakeAttrs default.devPkgs;

    checks = flake.perSystem.packages;

    legacyPackages = {
      lib = default.devLib;
      packages = default.devPkgs;
    };
  };

  flake.systemAgnostic = {
    inherit (default) overlays;
  };
in
flake
