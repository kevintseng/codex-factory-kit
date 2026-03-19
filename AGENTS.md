# Codex Working Policy

Use the factory workflow by default when the task is more than a trivial one-step edit.

## Lightweight Mode

For small, low-risk, single-scope tasks, use lightweight mode instead of the full loop.

Use lightweight mode when all of these are true:

- the change is confined to one module or one clear path
- no browser QA or multi-surface verification is obviously needed
- no migration, infra, security-sensitive, legal, or fintech risk is involved
- the user is asking for a small fix, small refactor, or bounded implementation

In lightweight mode:

1. Skip `office-hours-codex` unless the request is still vague.
2. Use `sprint-conductor` only to create or refresh `.codex/context/PLAN.md`.
3. Skip `TESTPLAN.md`, `RELEASE.md`, and `RETRO.md` unless the work grows in scope.
4. Skip `review-gate` for trivial local changes unless the risk rises or the user asks for review.
5. Still prefer repo-local agents for the implementation itself.

## Default Loop

1. If `.codex/context/` does not exist in the repo, use the `bootstrap-context` skill first.
2. For vague product or feature asks, use the `office-hours-codex` skill first.
3. For implementation work, use the `sprint-conductor` skill to create or refresh:
   - `.codex/context/PLAN.md`
   - `.codex/context/TESTPLAN.md`
4. Prefer repo-local agents in `.codex/agents/` before falling back to generic global agents.
5. Before merge- or ship-sensitive completion, use `review-gate`.
6. If UI, browser, route, or end-to-end behavior changed, use `qa-runtime`.
7. If behavior, setup, operations, or external contracts changed, use `document-release`.
8. After ship or a major completed workflow, use `retro`.

## Artifact Convention

Prefer repo-local context artifacts under `.codex/context/`:

- `PRODUCT.md`
- `PLAN.md`
- `TESTPLAN.md`
- `REVIEW.jsonl`
- `RELEASE.md`
- `RETRO.md`

Use templates from `$HOME/.codex/templates/factory/` when creating these files.

Treat `.codex/context/` as local working memory by default unless the repo or team explicitly wants these artifacts committed.

## Delegation Policy

- Keep the critical path local unless the user explicitly asks for delegation or parallel subagent work.
- When delegation is allowed, split ownership into disjoint scopes and prefer repo-local specialist agents.
- Use subagents for independent review, QA, or bounded implementation slices. Do not delegate urgent blocking work reflexively.

## Review Policy

- Findings first.
- Prefer precise evidence over broad warnings.
- Emit clear gate status: `PASS`, `PASS_WITH_CONCERNS`, or `FAIL`.

## QA Policy

- Do not claim runtime verification without runtime evidence.
- Prefer the existing Playwright skills for browser verification instead of inventing a second QA stack.

## Documentation Policy

- Keep docs and release notes aligned with actual shipped behavior.
- Do not invent capabilities, workflows, or guarantees in documentation.
