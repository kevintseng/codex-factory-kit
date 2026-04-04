# Codex Factory Kit Working Policy

This repository is a reusable workflow kit for Codex. It is not an application or a product repo with runtime business logic.

Use the factory workflow by default when the task is more than a trivial one-step edit, but keep the policy grounded in what this kit actually ships.

## Repo Identity

Treat these paths as the primary shipped contract:

- `AGENTS.md`
- `install.sh`
- `skills/*/SKILL.md`
- `skills/*/agents/openai.yaml`
- `templates/factory/*`
- `README.md`
- translated README files under the repo root
- `docs/*`

Treat these as local working or draft material unless the user explicitly asks to publish or commit them:

- `.codex/context/*`
- untracked files
- `docs/vnext/*` when they are present locally but not tracked in git

## Lightweight Mode

For small, low-risk, single-scope tasks, use lightweight mode instead of the full loop.

Use lightweight mode when all of these are true:

- the change is confined to one module or one clear path
- no browser QA or multi-surface verification is obviously needed
- no migration, infra, security-sensitive, legal, or fintech risk is involved
- the user is asking for a small fix, small refactor, bounded docs work, or a narrow implementation

In lightweight mode:

1. Skip `office-hours-codex` unless the request is still vague.
2. Use `sprint-conductor` only to create or refresh `.codex/context/PLAN.md`.
3. Skip `TESTPLAN.md`, `RELEASE.md`, and `RETRO.md` unless the work grows in scope.
4. Skip `review-gate` for trivial local changes unless the risk rises or the user asks for review.
5. Still prefer repo-local agents for the implementation itself.

## Default Loop

For non-trivial work where the route is not yet obvious, use `factory-router` first.

1. If `.codex/context/` does not exist in the repo, use the `bootstrap-context` skill first.
2. For vague product or feature asks, use the `office-hours-codex` skill first.
3. For implementation work, use the `sprint-conductor` skill to create or refresh:
   - `.codex/context/PLAN.md`
   - `.codex/context/TESTPLAN.md`
4. Prefer repo-local agents in `.codex/agents/` when they exist before falling back to generic global agents.
5. Before merge- or ship-sensitive completion, use `review-gate`.
6. If UI, browser, route, or end-to-end behavior changed, use `qa-runtime`.
7. If behavior, setup, operations, or external contracts changed, use `document-release`.
8. After ship or a major completed workflow, use `retro`.

## Repo-Specific Change Rules

When changing the workflow contract, keep the relevant surfaces aligned in the same pass.

### Skills

If a skill behavior changes, review and update together as needed:

- `skills/<skill>/SKILL.md`
- `skills/<skill>/agents/openai.yaml`
- `README.md`
- related docs under `docs/`
- `AGENTS.md` when the skill changes the default workflow or recommended entry path
- any factory template whose expected output changed

Do not rename public skill entrypoints casually. Skill names are part of the kit's external interface.

### Templates

If a template changes:

- keep the template consistent with the skill that writes it
- keep README and docs examples aligned with the new shape
- do not silently break existing repo-local artifacts without documenting the migration impact

### Installer

If install layout or shipped files change:

- verify `install.sh` still copies the right directories and filenames into `~/.codex`
- update install, quick-start, and adoption docs
- make versioning or migration implications explicit if the change affects existing installs

### Documentation

`README.md` is the canonical public description unless the user asks otherwise.

When public behavior or the workflow contract changes:

- update `README.md`
- update any stale docs in `docs/`
- keep translated README files aligned, or explicitly note that they are temporarily stale instead of letting them drift silently

Do not present draft vNext designs as shipped behavior unless the repo actually implements them.

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
- When reviewing this repo, focus on contract drift across skills, templates, installer behavior, and docs, not only on prose quality.

## QA Policy

- Do not claim runtime verification without runtime evidence.
- Prefer the existing Playwright skills for browser verification instead of inventing a second QA stack.
- For this repo, most tasks are docs, templates, and installer changes; verify the changed contract directly instead of inventing irrelevant runtime checks.

## Documentation Policy

- Keep docs and release notes aligned with actual shipped behavior.
- Do not invent capabilities, workflows, or guarantees in documentation.

## Release Policy

- Cut GitHub releases only for shipped functional improvements, meaningful feature additions, or real bug fixes.
- Do not cut releases for positioning changes, messaging changes, docs-only cleanup, PR workflow changes, or speculative vNext scaffolding.
- Require a version bump only when users can do something new, an existing workflow materially works better, or a real defect was fixed.
- Clearly distinguish among current shipped behavior, recommended usage, and vNext proposals.

## GitHub Messaging Policy

This repository is public and adoption-sensitive. Treat GitHub-facing text as part of the product surface.

- Prefer precise, maintainable commit messages first. Do not turn every commit into marketing copy.
- Use PR titles, PR bodies, squash-merge commit messages, release notes, and `docs/share.md` to express the user-facing value of a change more explicitly.
- When a change affects installation, onboarding, workflow behavior, public docs, or positioning, make the PR title and summary discoverable and product-aware.
- Keep the message concrete: what changed, who it helps, and why it matters for using Codex on real repos.
- Do not exaggerate. Never claim capabilities, integrations, or outcomes the repo does not actually ship.
- If a change materially affects how the project should be described publicly, update `README.md`, related docs, and `docs/share.md` in the same pass.
