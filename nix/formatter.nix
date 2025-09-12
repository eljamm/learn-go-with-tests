{
  lib,
  pkgs,
  inputs,
  system,
  ...
}@args:
let
  git-hooks = import inputs.git-hooks { inherit system; };
  treefmt-nix = import inputs.treefmt-nix;

  treefmt = treefmt-nix.mkWrapper pkgs {
    projectRootFile = "default.nix";
    programs.nixfmt.enable = true;
    programs.actionlint.enable = true;
    settings.formatter = {
      gofumpt = {
        command = "${lib.getExe pkgs.gofumpt}";
        options = [ "-w" ];
        includes = [ "*.go" ];
        excludes = [ "vendor/*" ];
      };
      goimports-reviser = {
        command = "${lib.getExe pkgs.goimports-reviser}";
        options = [
          "-format"
          "-apply-to-generated-files"
        ];
        includes = [ "*.go" ];
        excludes = [ "vendor/*" ];
      };
    };
  };
in
{
  pre-commit-hook = pkgs.writeShellScriptBin "git-hooks" ''
    if [[ -d .git ]]; then
      ${with git-hooks.lib.git-hooks; pre-commit (wrap.abort-on-change treefmt)}
    fi
  '';

  formatter = treefmt;
}
