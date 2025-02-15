{ inputs, ... }:
{
  imports = [
    inputs.git-hooks-nix.flakeModule
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { pkgs, lib, ... }:
    {
      treefmt.projectRootFile = "flake.nix";
      treefmt.programs.nixfmt.enable = true;
      treefmt.settings.formatter = {
        "gofumpt" = {
          command = "${lib.getExe pkgs.gofumpt}";
          options = [ "-w" ];
          includes = [ "*.go" ];
          excludes = [ "vendor/*" ];
        };
        "goimports-reviser" = {
          command = "${lib.getExe pkgs.goimports-reviser}";
          options = [
            "-format"
            "-apply-to-generated-files"
          ];
          includes = [ "*.go" ];
          excludes = [ "vendor/*" ];
        };
      };

      pre-commit.check.enable = true;
      pre-commit.settings.hooks.treefmt.enable = true;
      pre-commit.settings.hooks.treefmt.settings.no-cache = false;
    };
}
