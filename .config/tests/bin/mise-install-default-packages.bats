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

# Hook mode: run once from mise's global [hooks] postinstall, which passes a JSON
# list of everything that was just installed in MISE_INSTALLED_TOOLS.

# stub_in_tool <install-path> <cmd> : puts a stub <cmd> in <install-path>/bin that
# records which install it came from, so tests can check PATH was set per tool.
stub_in_tool() {
  mkdir -p "$1/bin"
  printf '#!/bin/sh\necho "%s $* [from %s]" >> "%s"\n' "$2" "$1" "$CALLS" > "$1/bin/$2"
  chmod +x "$1/bin/$2"
}

@test "hook mode installs defaults for each installed tool using that tool's bin dir" {
  printf 'neovim\n' > "$HOME/.config/mise/default-node-packages"
  printf 'ruff\n' > "$HOME/.config-local/mise/default-python-packages"
  node_path="$BATS_TEST_TMPDIR/installs/node/24"
  py_path="$BATS_TEST_TMPDIR/installs/python/3.12"
  stub_in_tool "$node_path" npm
  stub_in_tool "$py_path" pip
  export MISE_INSTALLED_TOOLS="[{\"name\":\"node\",\"version\":\"24\",\"install_path\":\"$node_path\"},{\"name\":\"python\",\"version\":\"3.12\",\"install_path\":\"$py_path\"}]"
  run env -u MISE_TOOL_NAME "$BIN_DIR/mise-install-default-packages"
  [ "$status" -eq 0 ]
  grep -qxF "npm install -g neovim [from $node_path]" "$CALLS"
  grep -qxF "pip install ruff [from $py_path]" "$CALLS"
}

@test "hook mode does nothing for an empty install list" {
  printf 'neovim\n' > "$HOME/.config/mise/default-node-packages"
  export MISE_INSTALLED_TOOLS='[]'
  run env -u MISE_TOOL_NAME "$BIN_DIR/mise-install-default-packages"
  [ "$status" -eq 0 ]
  [ ! -s "$CALLS" ]
}

@test "hook mode skips tools without defaults or an installer" {
  printf 'x\n' > "$HOME/.config/mise/default-java-packages"
  export MISE_INSTALLED_TOOLS="[{\"name\":\"java\",\"version\":\"21\",\"install_path\":\"$BATS_TEST_TMPDIR/j\"},{\"name\":\"uv\",\"version\":\"1\",\"install_path\":\"$BATS_TEST_TMPDIR/u\"}]"
  run env -u MISE_TOOL_NAME "$BIN_DIR/mise-install-default-packages"
  [ "$status" -eq 0 ]
  [ ! -s "$CALLS" ]
}

@test "hook mode go sets GOBIN to that install's bin dir" {
  printf 'example.com/a@latest\n' > "$HOME/.config/mise/default-go-packages"
  go_path="$BATS_TEST_TMPDIR/installs/go/1.26"
  mkdir -p "$go_path/bin"
  printf '#!/bin/sh\necho "go GOBIN=$GOBIN $*" >> "%s"\n' "$CALLS" > "$go_path/bin/go"
  chmod +x "$go_path/bin/go"
  export MISE_INSTALLED_TOOLS="[{\"name\":\"go\",\"version\":\"1.26\",\"install_path\":\"$go_path\"}]"
  run env -u MISE_TOOL_NAME "$BIN_DIR/mise-install-default-packages"
  [ "$status" -eq 0 ]
  [ "$(cat "$CALLS")" = "go GOBIN=$go_path/bin install example.com/a@latest" ]
}
