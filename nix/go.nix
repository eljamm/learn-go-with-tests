{
  pkgs,
  devLib,
  format,
  ...
}@args:
rec {
  shells.default = pkgs.mkShellNoCC {
    packages =
      with pkgs;
      [
        go
        format.formatter

        # LSP
        delve # debugger
        gopls

        # Tools
        go-tools
        gotestsum
        gotools
        gotestdox
      ]
      ++ aliases;

    # Required for Delve debugger
    # https://github.com/go-delve/delve/issues/3085
    hardeningDisable = [ "fortify" ];
  };

  aliases = devLib.mkAliases {
    # run tests in the current directory (as readable documentation)
    td = ''
      gotestdox ./... "$@"
    '';

    # watch go files and test on changes
    tw = ''
      gotestsum --format testname --watch-chdir --watch
    '';

    # run tests in the current directory (all from root)
    tt = ''
      gotestsum --format testname "$@"
    '';

    ff = format.formatter;
  };
}
