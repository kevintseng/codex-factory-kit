# Share Copy

## One-Line Description

Codex Factory Kit gives Codex a staged workflow with repo-local working memory, structured review, QA evidence, and a lightweight mode for small tasks.

## GitHub Repo Description

Codex-native factory workflow, skills, and templates for staged execution

## GitHub Topics

- codex
- openai
- ai-coding
- agent-workflow
- developer-tools
- prompt-engineering
- software-factory
- review-automation
- qa-automation
- ai-agents

## Short Post

I published `codex-factory-kit`, a Codex-native workflow layer for real repos.

It adds:

- repo-local working memory in `.codex/context/`
- staged execution instead of one-shot prompting
- structured review gates
- runtime QA evidence
- release + retro artifacts
- a lightweight mode for small tasks

Repo:

https://github.com/kevintseng/codex-factory-kit

## Longer Post

I wanted a better way to use Codex on real projects than just stacking prompts and hoping context survives.

So I packaged the workflow layer I have been using into a public repo:

`codex-factory-kit`

What it does:

- adds global Codex skills for planning, review, QA, release notes, and retros
- adds reusable templates for `PRODUCT.md`, `PLAN.md`, `TESTPLAN.md`, `REVIEW.jsonl`, `RELEASE.md`, and `RETRO.md`
- keeps project-specific agents local to each repo
- supports a lightweight mode so small tasks do not feel process-heavy

The goal is simple: make Codex work more like a software factory and less like a stateless prompt loop.

Repo:

https://github.com/kevintseng/codex-factory-kit
