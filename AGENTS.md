# Codex Working Policy

Use the factory workflow by default when the task is more than a trivial one-step edit.

For non-trivial work that needs explicit route selection, start with `factory-router` to classify:

- lightweight mode or full mode
- required follow-up skills
- model-fit expectations for lead versus worker execution
- whether `freeze` / `guard` should be used to keep the blast radius narrow

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
2. When the task needs explicit routing, use `factory-router` before implementation planning.
3. For vague product or feature asks, use the `office-hours-codex` skill first.
4. When `.codex/context/LEARNINGS.jsonl` contains relevant guidance for the task, use `learn` to sync that guidance into `PLAN.md` and `TESTPLAN.md`.
5. When the blast radius should stay deliberately narrow, use `freeze` before implementation.
6. For implementation work, use the `sprint-conductor` skill to create or refresh:
   - `.codex/context/PLAN.md`
   - `.codex/context/TESTPLAN.md`
7. Prefer repo-local agents in `.codex/agents/` before falling back to generic global agents.
8. If a freeze contract exists, use `guard` before merge- or ship-sensitive completion.
9. Before merge- or ship-sensitive completion, use `review-gate`.
10. If UI, browser, route, or end-to-end behavior changed, use `qa-runtime`.
11. If behavior, setup, operations, or external contracts changed, use `document-release`.
12. After ship or a major completed workflow, use `retro`.
13. When the retro exposes reusable cross-task guidance, use `learn` to promote it into `.codex/context/LEARNINGS.jsonl`.

## Artifact Convention

Prefer repo-local context artifacts under `.codex/context/`:

- `PRODUCT.md`
- `PLAN.md`
- `TESTPLAN.md`
- `REVIEW.jsonl`
- `RELEASE.md`
- `RETRO.md`
- `LEARNINGS.jsonl` for reusable cross-task guidance
- `FREEZE.md` when scope-locking a risky change

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

## Release Policy

- Cut releases only for shipped functional improvements, meaningful feature additions, or real bug fixes.
- Do not cut releases for docs-only cleanup, messaging changes, PR workflow changes, or internal planning work.

## Open Source Boundary

- Keep the public repo limited to shipped skills, installer behavior, templates, code, and user-facing docs.
- Keep internal planning notes, design explorations, roadmap drafts, and unpublished vNext concept material out of the public repo by default.
- Treat `docs/vnext/` as internal working material unless it is deliberately productized into shipped user-facing docs.
