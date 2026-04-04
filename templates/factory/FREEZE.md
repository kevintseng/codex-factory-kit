# Freeze Contract

Use this artifact only when the task should stay inside a deliberately narrow boundary.

## Intent
- Keep this change inside a small, explicit scope.

## Allowed Paths
- `path/to/allowed-area/**`

## Blocked Paths
- `VERSION`
- `CHANGELOG.md`

## Protected Invariants
- Do not widen the implementation scope without explicitly refreshing this contract.
- Do not claim the task stayed in-bounds unless `guard` passes against the current diff.

## Exit Criteria
- Remove or refresh this contract once the narrow-scope task is complete.
