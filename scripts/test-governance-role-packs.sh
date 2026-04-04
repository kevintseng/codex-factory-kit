#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_contains() {
  local path="$1"
  local pattern="$2"

  if ! grep -Fq -- "$pattern" "$path"; then
    fail "$path is missing required content: $pattern"
  fi
}

check_skill_contract() {
  local skill_name="$1"
  shift

  local skill_doc="$REPO_ROOT/skills/$skill_name/SKILL.md"
  local manifest="$REPO_ROOT/skills/$skill_name/agents/openai.yaml"

  [[ -f "$skill_doc" ]] || fail "missing skill doc for $skill_name"
  [[ -f "$manifest" ]] || fail "missing manifest for $skill_name"

  assert_contains "$skill_doc" 'This is a governance overlay. It does not replace `review-gate`.'
  assert_contains "$skill_doc" ".codex/context/REVIEW.jsonl"
  assert_contains "$skill_doc" "PASS_WITH_CONCERNS"
  assert_contains "$manifest" "review-gate"

  while [[ $# -gt 0 ]]; do
    assert_contains "$skill_doc" "$1"
    shift
  done
}

check_skill_contract \
  "founder-review" \
  "user value" \
  "adoption friction" \
  "messaging honesty"

check_skill_contract \
  "eng-review" \
  "maintainability" \
  "rollback and operability posture" \
  "long-term debt"

check_skill_contract \
  "design-review" \
  "workflow ergonomics" \
  "naming" \
  "user-facing docs"

check_skill_contract \
  "security-review" \
  "trust boundaries" \
  "secrets handling" \
  "unintended mutation surface"

check_skill_contract \
  "release-review" \
  "CHANGELOG.md" \
  "VERSION" \
  "whether the change actually deserves a release"

assert_contains "$REPO_ROOT/AGENTS.md" 'Optional governance overlays can add a founder, engineering, design, security, or release lens on top of `review-gate`.'
assert_contains "$REPO_ROOT/README.md" "## Governance Role Packs"
assert_contains "$REPO_ROOT/docs/adoption.md" 'Use `review-gate` as the default merge or ship gate.'
assert_contains "$REPO_ROOT/docs/examples.md" "## Example 9: Add A Governance Overlay Before Ship"
assert_contains "$REPO_ROOT/docs/share.md" "governance role packs"

printf 'PASS: governance role pack contracts are consistent\n'
