#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_REPO="$(mktemp -d /tmp/codex-factory-kit-guard-test-XXXXXX)"

cleanup() {
  rm -rf "$TMP_REPO"
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

cd "$TMP_REPO"
git init -q
git config user.name "Codex Factory Kit Test"
git config user.email "test@example.com"

mkdir -p src docs .codex/context
printf 'hello\n' > src/allowed.txt
printf 'base\n' > README.md
cat > .codex/context/FREEZE.md <<'EOF'
# Freeze Contract

## Intent
- Keep the change inside src only.

## Allowed Paths
- `src/**`

## Blocked Paths
- `README.md`

## Protected Invariants
- Do not widen scope without refreshing the contract.

## Exit Criteria
- Remove or refresh after the task finishes.
EOF

git add .
git commit -q -m "init"

printf 'updated\n' >> src/allowed.txt
pass_output="$("$REPO_ROOT/scripts/check-freeze-boundary.sh" --repo-root "$TMP_REPO")"
assert_contains "$pass_output" "guard_status=PASS"

git checkout -- src/allowed.txt
printf 'changed\n' >> README.md

set +e
base_ref_output="$("$REPO_ROOT/scripts/check-freeze-boundary.sh" --repo-root "$TMP_REPO" --base-ref HEAD 2>&1)"
base_ref_code=$?
set -e

if [ "$base_ref_code" -eq 0 ]; then
  fail "guard with --base-ref should still fail for working-tree violations"
fi

assert_contains "$base_ref_output" "violation=blocked:README.md"

set +e
fail_output="$("$REPO_ROOT/scripts/check-freeze-boundary.sh" --repo-root "$TMP_REPO" 2>&1)"
fail_code=$?
set -e

if [ "$fail_code" -eq 0 ]; then
  fail "guard should fail for blocked or out-of-boundary changes"
fi

assert_contains "$fail_output" "guard_status=FAIL"
assert_contains "$fail_output" "violation=blocked:README.md"

printf 'PASS: freeze and guard contract checks\n'
