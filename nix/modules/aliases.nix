{
  perSystem =
    { pkgs, devLib, ... }:
    {
      devShells.aliases = pkgs.mkShell {
        packages = devLib.mkAliases {
          # run tests in the current directory (all from root)
          tt = ''
            gotestsum --format testname "$@"
          '';

          # run tests in the current directory (as readable documentation)
          td = ''
            gotestdox ./... "$@"
          '';

          # watch go files and test on changes
          tw = ''
            gotestsum --format testname --watch-chdir --watch
          '';
        };
      };
    };
}
