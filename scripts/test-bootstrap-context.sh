#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_CODEX_HOME="$(mktemp -d /tmp/codex-factory-kit-bootstrap-home-XXXXXX)"
TMP_REPO="$(mktemp -d /tmp/codex-factory-kit-bootstrap-repo-XXXXXX)"

cleanup() {
  rm -rf "$TMP_CODEX_HOME" "$TMP_REPO"
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

cd "$REPO_ROOT"
CODEX_HOME="$TMP_CODEX_HOME" bash ./install.sh >/tmp/codex-factory-kit-bootstrap-install.log

git -C "$TMP_REPO" init -q
printf '# temp repo\n' > "$TMP_REPO/README.md"
printf 'custom plan\n' > "$TMP_REPO/.codex-plan-sentinel"

bootstrap_output="$("$TMP_CODEX_HOME/factory-kit/init-repo.sh" --repo "$TMP_REPO" --codex-home "$TMP_CODEX_HOME")"

for path in \
  "$TMP_REPO/.codex/context/PRODUCT.md" \
  "$TMP_REPO/.codex/context/PLAN.md" \
  "$TMP_REPO/.codex/context/TESTPLAN.md" \
  "$TMP_REPO/.codex/context/RELEASE.md" \
  "$TMP_REPO/.codex/context/RETRO.md" \
  "$TMP_REPO/.codex/context/REVIEW.jsonl" \
  "$TMP_REPO/.codex/context/LEARNINGS.jsonl"
do
  if [ ! -f "$path" ]; then
    fail "expected bootstrap to create $path"
  fi
done

if ! grep -qxF '.codex/context/' "$TMP_REPO/.gitignore"; then
  fail "bootstrap should add .codex/context/ to .gitignore"
fi

assert_contains "$bootstrap_output" "bootstrap_status=updated"
assert_contains "$bootstrap_output" "next_step=Open Codex in this repo and say:"

printf 'custom plan\n' > "$TMP_REPO/.codex/context/PLAN.md"
second_output="$("$TMP_CODEX_HOME/factory-kit/init-repo.sh" --repo "$TMP_REPO" --codex-home "$TMP_CODEX_HOME")"

if [ "$(cat "$TMP_REPO/.codex/context/PLAN.md")" != "custom plan" ]; then
  fail "bootstrap should preserve existing PLAN.md"
fi

gitignore_count="$(grep -c '^\.codex/context/$' "$TMP_REPO/.gitignore")"
if [ "$gitignore_count" -ne 1 ]; then
  fail "bootstrap should not duplicate the .gitignore entry"
fi

assert_contains "$second_output" "bootstrap_status=already_initialized"

printf 'PASS: bootstrap-context helper checks\n'
