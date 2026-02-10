# Description

Learning Go through test-driven development, with the help of the [quii/learn-go-with-tests](https://github.com/quii/learn-go-with-tests) e-book.

# Usage

This project is powered by [Nix](https://nixos.org), making it fully
declarative and reproducible.

All you have to do is enter the development environment with:

```shellSession
nix-shell
```

or if you have flakes enable:

```shellSession
nix develop
```

Inside the environment, you can use the `go-test` or `tt` commands to run the tests.

For a full list of commands/shell aliases, see [`nix/go.nix`](./nix/go.nix).
