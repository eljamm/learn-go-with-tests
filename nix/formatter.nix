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

  treefmt-cfg = {
    projectRootFile = "default.nix";
    programs.nixfmt.enable = true;
    programs.actionlint.enable = true;
    programs.zizmor.enable = true;
    programs.gofumpt.enable = true;
    programs.golines.enable = true;
    programs.goimports = {
      enable = true;
      package = pkgs.goimports-reviser;
    };
    settings.formatter.goimports = {
      command = lib.mkForce "${lib.getExe pkgs.goimports-reviser}";
      options = lib.mkForce [
        "-format"
        "-apply-to-generated-files"
      ];
    };
  };
  treefmt = treefmt-nix.mkWrapper pkgs treefmt-cfg;
  treefmt-pkgs = (treefmt-nix.evalModule pkgs treefmt-cfg).config.build.devShell.nativeBuildInputs;
in
{
  pre-commit-hook = pkgs.writeShellScriptBin "git-hooks" ''
    if [[ -d .git ]]; then
      ${with git-hooks.lib.git-hooks; pre-commit (wrap.abort-on-change treefmt)}
    fi
  '';

  formatter = treefmt;
  formatter-pkgs = treefmt-pkgs;
}
