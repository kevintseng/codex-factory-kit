#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_CODEX_HOME="$(mktemp -d /tmp/codex-factory-kit-release-check-XXXXXX)"
FIXTURE_FILE="$REPO_ROOT/scripts/fixtures/latest-release.json"

cleanup() {
  rm -rf "$TMP_CODEX_HOME"
}

trap cleanup EXIT

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_contains() {
  local haystack="$1"
  local needle="$2"

  if [[ "$haystack" != *"$needle"* ]]; then
    fail "expected output to contain: $needle"
  fi
}

assert_file_contains() {
  local file="$1"
  local needle="$2"

  if ! grep -Fq "$needle" "$file"; then
    fail "expected $file to contain: $needle"
  fi
}

cd "$REPO_ROOT"
CODEX_HOME="$TMP_CODEX_HOME" bash ./install.sh >/tmp/codex-factory-kit-release-install.log

check_output="$(
  ./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates \
    --codex-home "$TMP_CODEX_HOME" \
    --release-json-file "$FIXTURE_FILE"
)"

assert_contains "$check_output" "release_authority=kevintseng/codex-factory-kit"
assert_contains "$check_output" "latest_release_tag=v0.1.1"
assert_contains "$check_output" "latest_release_version=0.1.1"
assert_contains "$check_output" "installed_release_relation=ahead"
assert_contains "$check_output" "source_release_relation=ahead"
assert_contains "$check_output" "update_available=no"

state_file="$TMP_CODEX_HOME/factory-kit/update-state.json"
[ -f "$state_file" ] || fail "expected update-state.json to be written"
assert_file_contains "$state_file" "\"latest_release_version\": \"0.1.1\""
assert_file_contains "$state_file" "\"installed_release_relation\": \"ahead\""

printf '0.1.0\n' > "$TMP_CODEX_HOME/factory-kit/VERSION"
behind_output="$(
  ./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates \
    --codex-home "$TMP_CODEX_HOME" \
    --release-json-file "$FIXTURE_FILE"
)"
assert_contains "$behind_output" "installed_version=0.1.0"
assert_contains "$behind_output" "installed_release_relation=behind"
assert_contains "$behind_output" "update_available=yes"

printf 'garbage\n' > "$TMP_CODEX_HOME/factory-kit/VERSION"
unknown_output="$(
  ./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates \
    --codex-home "$TMP_CODEX_HOME" \
    --release-json-file "$FIXTURE_FILE"
)"
assert_contains "$unknown_output" "installed_version=garbage"
assert_contains "$unknown_output" "installed_release_relation=unknown"
assert_contains "$unknown_output" "update_available=unknown"

printf '/does/not/exist\n' > "$TMP_CODEX_HOME/factory-kit/SOURCE_REPO"
unknown_source_output="$(
  cd /tmp && "$TMP_CODEX_HOME/skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh" check-updates \
    --codex-home "$TMP_CODEX_HOME" \
    --release-json-file "$FIXTURE_FILE"
)"
assert_contains "$unknown_source_output" "source_repo=unknown"
assert_contains "$unknown_source_output" "source_release_relation=unknown"

printf 'PASS: release-check layer contract checks\n'
