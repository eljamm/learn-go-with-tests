{
  src,
  ...
}@args:
let
  flake-inputs = import (
    fetchTarball "https://github.com/fricklerhandwerk/flake-inputs/tarball/4.1.0"
  );
in
flake-inputs.import-flake args
