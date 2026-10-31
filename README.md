# homebrew-tap-testing

A [Homebrew](https://brew.sh) tap for testing releases of
[`oxidecomputer/cargo-dist`](https://github.com/oxidecomputer/cargo-dist).

The release workflow in
[`oxidecomputer/dist-test`](https://github.com/oxidecomputer/dist-test)
publishes the formulas in this tap. Don't install them for anything other than
testing. For Oxide tools, use
[`oxidecomputer/homebrew-tap`](https://github.com/oxidecomputer/homebrew-tap).

## Usage

Add the tap:

```sh
brew tap oxidecomputer/tap-testing
```

Install or upgrade the test program:

```sh
brew install oxidecomputer/tap-testing/dist-test
brew upgrade oxidecomputer/tap-testing/dist-test
```

Uninstall the test program and remove the tap:

```sh
brew list --formula --full-name | grep '^oxidecomputer/tap-testing/' | xargs brew uninstall
brew untap oxidecomputer/tap-testing
```
