---
name: "guard"
description: "Use when a freeze contract exists and you need to verify that the current diff stayed inside the declared boundary. Runs the guard check and reports PASS or FAIL with concrete violations."
---

# Guard

Use this skill after implementation, or before review/merge-sensitive completion, when `.codex/context/FREEZE.md` defines a narrow edit boundary that should now be checked.

This is the verification half of the safety layer.

## Primary Check

Run:

```bash
./scripts/check-freeze-boundary.sh
```

Optional flags:

```bash
./scripts/check-freeze-boundary.sh --freeze-file .codex/context/FREEZE.md
./scripts/check-freeze-boundary.sh --repo-root /path/to/repo
./scripts/check-freeze-boundary.sh --base-ref origin/main
```

## Expected Behavior

`guard` should:

- read `.codex/context/FREEZE.md`
- inspect the changed files in the current repo
- fail when a changed file is outside the allowed path set
- fail when a changed file matches a blocked path
- report `guard_status=PASS` or `guard_status=FAIL` with concrete violating files

## Workflow

1. Confirm that `.codex/context/FREEZE.md` exists and is current.
2. Run `./scripts/check-freeze-boundary.sh`.
3. If the guard fails, either narrow the diff or deliberately refresh the freeze contract before continuing.
4. If the guard passes, carry that result into `review-gate` or the final completion summary.

## Guardrails

- `guard` does not replace `review-gate`.
- Do not silently widen the freeze contract just to make the current diff pass.
- Prefer a concrete failure with file-level evidence over broad warnings.
- If no freeze contract exists, say so and stop instead of inventing one implicitly.
