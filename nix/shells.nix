{
  pkgs,
  default,
  formatter,
  ...
}:
{
  default = pkgs.mkShellNoCC {
    inputsFrom = [
      default.go.shells.default
      formatter.shell
    ];
    packages = with pkgs; [
      formatter.package
      gitMinimal
    ];
    shellHook = ''
      export PROJECT_ROOT="$(git rev-parse --show-toplevel)"

      # compat with IDEs
      ln -sf "${formatter.configFile}" "$PROJECT_ROOT/treefmt.toml"
    '';
  };
}
