{
  lib,
  pkgs,
  inputs,
  ...
}:
lib.makeExtensible (self: {
  treefmt = import inputs.treefmt-nix;

  config = {
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

    settings.formatter.editorconfig-checker = {
      command = pkgs.editorconfig-checker;
      includes = [ "*" ];
      priority = 9; # last
    };
  };

  # evaluated config
  eval = self.treefmt.evalModule pkgs self.config;
  configFile = self.eval.config.build.configFile;

  # treefmt package
  package = self.eval.config.build.wrapper;

  # development shell that contains all formatters
  shell = self.eval.config.build.devShell;
})
