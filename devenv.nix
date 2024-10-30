{
  lib,
  pkgs,
  ...
}:
{
  cachix.enable = false;

  packages = with pkgs; [
    # Formatting
    gofumpt
    goimports-reviser
    golines

    # LSP
    delve # debugger
    gopls

    # Tools
    go-tools
    gotestsum
    gotools
    gotestdox
  ];

  languages.go.enable = true;

  # Required for Delve debugger
  # https://github.com/go-delve/delve/issues/3085
  languages.go.enableHardeningWorkaround = true;

  # Aliases
  scripts = {
    # run tests in the current directory (all from root)
    tt.exec = ''
      gotestsum --format testname "$@"
    '';

    # run tests in the current directory (as readable documentation)
    td.exec = ''
      gotestdox ./... "$@"
    '';

    # watch go files and test on changes
    tw.exec = ''
      gotestsum --format testname --watch-chdir --watch
    '';
  };
}
