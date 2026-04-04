#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_CODEX_HOME="$(mktemp -d /tmp/codex-factory-kit-upgrade-test-XXXXXX)"

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

assert_equals() {
  local actual="$1"
  local expected="$2"
  local label="$3"

  if [ "$actual" != "$expected" ]; then
    fail "$label expected '$expected' but got '$actual'"
  fi
}

run_status() {
  "$1" status --codex-home "$TMP_CODEX_HOME"
}

run_upgrade() {
  "$1" upgrade --codex-home "$TMP_CODEX_HOME"
}

cd "$REPO_ROOT"

CODEX_HOME="$TMP_CODEX_HOME" bash ./install.sh

stored_source="$(cat "$TMP_CODEX_HOME/factory-kit/SOURCE_REPO")"
assert_equals "$stored_source" "$REPO_ROOT" "stored source repo"

installed_script="$TMP_CODEX_HOME/skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh"
status_from_tmp="$(cd /tmp && "$installed_script" status --codex-home "$TMP_CODEX_HOME")"
assert_contains "$status_from_tmp" "source_repo=$REPO_ROOT"
assert_contains "$status_from_tmp" "source_version=$(cat "$REPO_ROOT/VERSION")"
assert_contains "$status_from_tmp" "version_relation=current"
assert_contains "$status_from_tmp" "update_available=no"

printf '9.9.9\n' > "$TMP_CODEX_HOME/factory-kit/VERSION"

downgrade_status="$(run_status ./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh)"
assert_contains "$downgrade_status" "installed_version=9.9.9"
assert_contains "$downgrade_status" "version_relation=downgrade"
assert_contains "$downgrade_status" "update_available=no"

set +e
downgrade_output="$(run_upgrade ./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh 2>&1)"
downgrade_code=$?
set -e

if [ "$downgrade_code" -eq 0 ]; then
  fail "downgrade without --allow-downgrade should fail"
fi

assert_contains "$downgrade_output" "Refusing to overwrite installed_version=9.9.9"

allow_output="$(
  ./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh upgrade \
    --codex-home "$TMP_CODEX_HOME" \
    --allow-downgrade
)"
assert_contains "$allow_output" "version_relation=downgrade"
assert_contains "$allow_output" "installed_version=$(cat "$REPO_ROOT/VERSION")"

printf '/does/not/exist\n' > "$TMP_CODEX_HOME/factory-kit/SOURCE_REPO"
unknown_status="$(cd /tmp && "$installed_script" status --codex-home "$TMP_CODEX_HOME")"
assert_contains "$unknown_status" "source_repo=unknown"
assert_contains "$unknown_status" "source_version=unknown"
assert_contains "$unknown_status" "version_relation=unknown"
assert_contains "$unknown_status" "update_available=unknown"

ordered_status="$(
  ./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh \
    --codex-home "$TMP_CODEX_HOME" \
    status
)"
assert_contains "$ordered_status" "version_relation=current"

tags="$(git tag --list --sort=version:refname)"
assert_contains "$tags" "v0.1.0"
assert_contains "$tags" "v0.1.1"
if grep -q '^## 0.0.1$' CHANGELOG.md; then
  fail "CHANGELOG.md should not contain a 0.0.1 section"
fi

printf 'PASS: upgrade foundation contract checks\n'
