#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d /tmp/codex-factory-kit-learning-XXXXXX)"
CONTEXT_DIR="$TMP_DIR/.codex/context"
SCRIPT_PATH="$REPO_ROOT/skills/learn/scripts/factory-kit-learn.py"
PLAN_TEMPLATE="$REPO_ROOT/templates/factory/PLAN.md"
TESTPLAN_TEMPLATE="$REPO_ROOT/templates/factory/TESTPLAN.md"

cleanup() {
  rm -rf "$TMP_DIR"
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

  if ! grep -Fq -- "$needle" "$file"; then
    fail "expected $file to contain: $needle"
  fi
}

mkdir -p "$CONTEXT_DIR"
cp "$PLAN_TEMPLATE" "$CONTEXT_DIR/PLAN.md"
cp "$TESTPLAN_TEMPLATE" "$CONTEXT_DIR/TESTPLAN.md"
cat > "$CONTEXT_DIR/RETRO.md" <<'EOF'
# Retrospective

## What Broke Or Slowed Us Down
- Browser QA caught the checkout funnel regression again.
EOF

capture_output="$(
  python3 "$SCRIPT_PATH" --context-dir "$CONTEXT_DIR" capture \
    --task-class checkout_flow \
    --kind qa_requirement \
    --summary "Checkout funnel edits usually need browser QA." \
    --guidance "Require qa-runtime for checkout funnel UI changes." \
    --applies-when "The task changes a browser-facing checkout path." \
    --recommended-action "Set needs_qa_runtime=true and verification_level=browser." \
    --tag browser \
    --tag checkout \
    --confidence high
)"

assert_contains "$capture_output" "learning_id="
assert_contains "$capture_output" "learnings_path=$CONTEXT_DIR/LEARNINGS.jsonl"

LEARNINGS_FILE="$CONTEXT_DIR/LEARNINGS.jsonl"
[ -f "$LEARNINGS_FILE" ] || fail "expected learnings store to exist"
assert_file_contains "$LEARNINGS_FILE" "\"task_class\": \"checkout_flow\""
assert_file_contains "$LEARNINGS_FILE" "\"active\": true"

promote_output="$(
  python3 "$SCRIPT_PATH" --context-dir "$CONTEXT_DIR" promote-retro \
    --task-class release_workflow \
    --kind release_ops \
    --summary "Behavior changes usually need docs and changelog updates." \
    --guidance "Run document-release whenever shipped behavior changes." \
    --applies-when "The task changes user-visible behavior or setup." \
    --recommended-action "Set needs_document_release=true before completion." \
    --tag release \
    --tag docs \
    --confidence high
)"

assert_contains "$promote_output" "learning_id="
assert_file_contains "$LEARNINGS_FILE" "\"source_type\": \"retro\""
assert_file_contains "$LEARNINGS_FILE" "\"source_file\": \"$CONTEXT_DIR/RETRO.md\""

recommend_output="$(
  python3 "$SCRIPT_PATH" --context-dir "$CONTEXT_DIR" recommend \
    --task-class checkout_flow \
    --tag browser \
    --format jsonl
)"

assert_contains "$recommend_output" "\"task_class\": \"checkout_flow\""
assert_contains "$recommend_output" "\"recommended_action\": \"Set needs_qa_runtime=true and verification_level=browser.\""

recommend_with_deferred_context="$(
  python3 "$SCRIPT_PATH" recommend \
    --task-class checkout_flow \
    --tag browser \
    --format jsonl \
    --context-dir "$CONTEXT_DIR"
)"

assert_contains "$recommend_with_deferred_context" "\"task_class\": \"checkout_flow\""
assert_contains "$recommend_with_deferred_context" "\"recommended_action\": \"Set needs_qa_runtime=true and verification_level=browser.\""

sync_output="$(
  python3 "$SCRIPT_PATH" sync-context \
    --task-class checkout_flow \
    --tag browser \
    --context-dir "$CONTEXT_DIR"
)"

assert_contains "$sync_output" "matched_count=1"
assert_contains "$sync_output" "plan_path=$CONTEXT_DIR/PLAN.md"
assert_contains "$sync_output" "testplan_path=$CONTEXT_DIR/TESTPLAN.md"
assert_file_contains "$CONTEXT_DIR/PLAN.md" "- Relevant learnings: 1 active guidance item(s)"
assert_file_contains "$CONTEXT_DIR/PLAN.md" "["
assert_file_contains "$CONTEXT_DIR/PLAN.md" "Checkout funnel edits usually need browser QA."
assert_file_contains "$CONTEXT_DIR/TESTPLAN.md" "- Relevant learnings: 1 active guidance item(s)"
assert_file_contains "$CONTEXT_DIR/TESTPLAN.md" "Set needs_qa_runtime=true and verification_level=browser."

first_learning_id="$(
  python3 - "$LEARNINGS_FILE" <<'PY'
import json
import sys
with open(sys.argv[1], "r", encoding="utf-8") as handle:
    first = json.loads(handle.readline())
print(first["learning_id"])
PY
)"

deactivate_output="$(
  python3 "$SCRIPT_PATH" --context-dir "$CONTEXT_DIR" deactivate \
    --learning-id "$first_learning_id"
)"

assert_contains "$deactivate_output" "active=false"

recommend_after_deactivate="$(
  python3 "$SCRIPT_PATH" --context-dir "$CONTEXT_DIR" recommend \
    --task-class checkout_flow \
    --tag browser \
    --format jsonl
)"

if [[ "$recommend_after_deactivate" == *"checkout_flow"* ]]; then
  fail "expected deactivated learning to disappear from recommend output"
fi

sync_after_deactivate="$(
  python3 "$SCRIPT_PATH" --context-dir "$CONTEXT_DIR" sync-context \
    --task-class checkout_flow \
    --tag browser
)"

assert_contains "$sync_after_deactivate" "matched_count=0"
assert_file_contains "$CONTEXT_DIR/PLAN.md" "- Relevant learnings: none"
assert_file_contains "$CONTEXT_DIR/PLAN.md" "## Relevant Learnings"
assert_file_contains "$CONTEXT_DIR/PLAN.md" "- None yet."
assert_file_contains "$CONTEXT_DIR/TESTPLAN.md" "- Relevant learnings: none"

list_all_output="$(
  python3 "$SCRIPT_PATH" --context-dir "$CONTEXT_DIR" list --all --format jsonl
)"

assert_contains "$list_all_output" "\"active\": false"
assert_contains "$list_all_output" "\"task_class\": \"release_workflow\""

printf 'PASS: learning layer contract checks\n'
