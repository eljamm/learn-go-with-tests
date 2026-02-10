{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.url = "github:fricklerhandwerk/git-hooks";
    git-hooks.flake = false;
  };

  # import flake attributes from ./flake/default.nix
  outputs =
    { self, ... }@inputs:
    let
      inherit (inputs.flake-utils.lib)
        eachDefaultSystem
        eachDefaultSystemPassThrough
        ;

      importFlake = arg: (system: (import ./. { inherit self inputs system; }).flake.${arg} or { });

      # independant of system (e.g. nixosModules)
      systemAgnosticFlake = eachDefaultSystemPassThrough (importFlake "systemAgnostic");

      # depends on system (e.g. packages.x86_64-linux)
      perSystemFlake = eachDefaultSystem (importFlake "perSystem");
    in
    systemAgnosticFlake // perSystemFlake;
}
