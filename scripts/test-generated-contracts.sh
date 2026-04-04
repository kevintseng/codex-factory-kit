#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d /tmp/codex-factory-kit-generated-XXXXXX)"

cleanup() {
  rm -rf "$TMP_DIR"
}

trap cleanup EXIT

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

cd "$REPO_ROOT"
python3 scripts/generate-factory-contracts.py --output-dir "$TMP_DIR"

for file in \
  skill-index.md \
  capability-matrix.md \
  AGENTS-routing-snippet.md \
  install-upgrade-reference.md \
  install-manifest.json
do
  if ! diff -u "docs/generated/$file" "$TMP_DIR/$file" >/tmp/codex-factory-kit-generated.diff; then
    cat /tmp/codex-factory-kit-generated.diff >&2
    fail "generated contract drift detected for $file"
  fi
done

python3 - "$TMP_DIR/install-manifest.json" <<'PY'
import json
import sys
with open(sys.argv[1], "r", encoding="utf-8") as handle:
    data = json.load(handle)
assert "factory-router" in data["skills"]
assert "learn" in data["skills"]
assert "LEARNINGS.jsonl.example" in data["templates"]
assert "check-updates" in data["upgrade_commands"]
PY

printf 'PASS: generated contracts are up to date\n'
