#!/usr/bin/env bats

# mise-install-default-packages is run as a mise tool `postinstall`. It reads
# MISE_TOOL_NAME and installs the merged default-<tool>-packages lists from
# ~/.config/mise and ~/.config-local/mise. These tests stub the package managers
# so nothing is really installed.

setup() {
  BIN_DIR="$(cd "$BATS_TEST_DIRNAME/../../bin" && pwd -P)"
  export HOME="$BATS_TEST_TMPDIR/home"
  STUBS="$BATS_TEST_TMPDIR/stubs"
  CALLS="$BATS_TEST_TMPDIR/calls"
  mkdir -p "$HOME/.config/mise" "$HOME/.config-local/mise" "$STUBS"
  : > "$CALLS"
  for cmd in npm pip gem go; do
    printf '#!/bin/sh\necho "%s $*" >> "%s"\n' "$cmd" "$CALLS" > "$STUBS/$cmd"
    chmod +x "$STUBS/$cmd"
  done
  export PATH="$STUBS:$PATH"
  export MISE_TOOL_INSTALL_PATH="$BATS_TEST_TMPDIR/install"
}

@test "merges public and local lists, dedupes, and runs npm install -g for node" {
  printf 'neovim\nhttp-server\n\n' > "$HOME/.config/mise/default-node-packages"
  printf 'neovim\nprettier\n' > "$HOME/.config-local/mise/default-node-packages"
  MISE_TOOL_NAME=node run "$BIN_DIR/mise-install-default-packages"
  [ "$status" -eq 0 ]
  [ "$(cat "$CALLS")" = "npm install -g http-server neovim prettier" ]
}

@test "uses only the local list when no public list exists" {
  printf 'ruff\npylint\n' > "$HOME/.config-local/mise/default-python-packages"
  MISE_TOOL_NAME=python run "$BIN_DIR/mise-install-default-packages"
  [ "$status" -eq 0 ]
  [ "$(cat "$CALLS")" = "pip install pylint ruff" ]
}

@test "installs gems for ruby" {
  printf 'neovim\n' > "$HOME/.config/mise/default-ruby-packages"
  MISE_TOOL_NAME=ruby run "$BIN_DIR/mise-install-default-packages"
  [ "$status" -eq 0 ]
  [ "$(cat "$CALLS")" = "gem install neovim" ]
}

@test "go installs each package into the tool's bin dir" {
  printf 'example.com/a@latest\nexample.com/b@latest\n' > "$HOME/.config/mise/default-go-packages"
  printf '#!/bin/sh\necho "go GOBIN=$GOBIN $*" >> "%s"\n' "$CALLS" > "$STUBS/go"
  MISE_TOOL_NAME=go run "$BIN_DIR/mise-install-default-packages"
  [ "$status" -eq 0 ]
  [ "$(sed -n 1p "$CALLS")" = "go GOBIN=$MISE_TOOL_INSTALL_PATH/bin install example.com/a@latest" ]
  [ "$(sed -n 2p "$CALLS")" = "go GOBIN=$MISE_TOOL_INSTALL_PATH/bin install example.com/b@latest" ]
}

@test "does nothing when the list is empty or missing" {
  : > "$HOME/.config-local/mise/default-node-packages"
  MISE_TOOL_NAME=node run "$BIN_DIR/mise-install-default-packages"
  [ "$status" -eq 0 ]
  [ ! -s "$CALLS" ]
  MISE_TOOL_NAME=ruby run "$BIN_DIR/mise-install-default-packages"
  [ "$status" -eq 0 ]
  [ ! -s "$CALLS" ]
}

@test "ignores tools it has no installer for" {
  printf 'x\n' > "$HOME/.config/mise/default-java-packages"
  MISE_TOOL_NAME=java run "$BIN_DIR/mise-install-default-packages"
  [ "$status" -eq 0 ]
  [ ! -s "$CALLS" ]
}

@test "fails when MISE_TOOL_NAME is unset" {
  run env -u MISE_TOOL_NAME "$BIN_DIR/mise-install-default-packages"
  [ "$status" -ne 0 ]
}
