#!/usr/bin/env bats

setup() {
  load "$BATS_PLUGIN_PATH/load.bash"

  # Uncomment to enable stub debugging
  # export GIT_STUB_DEBUG=/dev/tty
}

@test "uses latest version if no version set" {
  stub curl
  run "$PWD/hooks/environment"

  assert_output --partial "--- Installing runreal-latest"
}

@test "sets the plugin version correctly" {
  export BUILDKITE_PLUGIN_RUNREAL_VERSION="1.0.0"

  stub curl
  run "$PWD/hooks/environment"

  assert_output --partial "--- Installing runreal-1.0.0"
}

@test "uses correct url for windows platform" {
  export BUILDKITE_PLUGIN_RUNREAL_VERSION="1.0.0"

  stub uname "-s : echo MINGW64_NT-10.0"
  stub curl
  run "$PWD/hooks/environment"

  assert_output --partial "https://github.com/runreal/cli/releases/download/v1.0.0/runreal-win-x64.exe"
}

@test "uses correct url for linux platform" {
  export BUILDKITE_PLUGIN_RUNREAL_VERSION="1.0.0"

  stub uname "-s : echo Linux"
  stub curl
  run "$PWD/hooks/environment"

  assert_output --partial "https://github.com/runreal/cli/releases/download/v1.0.0/runreal-linux-x64"
}

@test "uses correct url for macos platform" {
  export BUILDKITE_PLUGIN_RUNREAL_VERSION="1.0.0"

  stub uname "-s : echo Darwin"
  stub curl
  run "$PWD/hooks/environment"

  assert_output --partial "https://github.com/runreal/cli/releases/download/v1.0.0/runreal-macos-arm"
}
