#!/usr/bin/env bats
load test_helper

setup() {
  dokku apps:create my_app >&2
  dokku "$PLUGIN_COMMAND_PREFIX:create" l >&2
  dokku "$PLUGIN_COMMAND_PREFIX:link" l my_app >&2
}

teardown() {
  dokku "$PLUGIN_COMMAND_PREFIX:unlink" l my_app >&2
  dokku --force "$PLUGIN_COMMAND_PREFIX:destroy" l >&2
  rm -rf "$DOKKU_ROOT/my_app"
}

@test "($PLUGIN_COMMAND_PREFIX:hook:pre-delete) removes app from links file when destroying app" {
  cat "$PLUGIN_DATA_ROOT/l/LINKS"
  [[ -n $(< "$PLUGIN_DATA_ROOT/l/LINKS") ]]
  dokku --force apps:destroy my_app
  cat "$PLUGIN_DATA_ROOT/l/LINKS"
  [[ -z $(< "$PLUGIN_DATA_ROOT/l/LINKS") ]]
}
