{
  perSystem =
    {
      config,
      self',
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        inputsFrom = [
          self'.devShells.aliases
          config.pre-commit.devShell
          config.treefmt.build.devShell
        ];

        packages = with pkgs; [
          go

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

        # Required for Delve debugger
        # https://github.com/go-delve/delve/issues/3085
        hardeningDisable = [ "fortify" ];
      };
    };
}
