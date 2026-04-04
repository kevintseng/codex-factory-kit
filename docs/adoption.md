# Adoption Notes

## Safe First Step

Start by installing the skills and templates without changing your global policy:

```bash
./install.sh
```

Then read:

- `~/.codex/AGENTS.factory-kit.md`

Merge that into `~/.codex/AGENTS.md` only if you want the factory loop to become the default.

A good first use after install is to ask `factory-router` whether your next non-trivial task should stay lightweight or use the full loop.

## Recommended Repo Setup

For repos where you want persistent working memory:

1. create `.codex/context/`
2. seed it from the factory templates
3. add `.codex/context/` to `.gitignore`

## Recommended Rollout

Do not force this on every repo immediately.

A better order is:

1. one active product repo
2. one infrastructure or backend repo
3. one UI-heavy repo where `qa-runtime` is useful

## Where It Helps Most

- multi-step tasks
- code review and ship gates
- browser QA
- AI-heavy or domain-heavy repos
- cases where work spans multiple sessions

## Where To Stay Lightweight

- tiny one-file fixes
- quick local refactors
- chores where runtime verification is unnecessary
