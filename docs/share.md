# Share Copy

## One-Line Description

Codex Factory Kit gives Codex a staged workflow with repo-local working memory, a first-class task router, a local release-check and upgrade layer, a narrow-scope safety layer, structured review, QA evidence, and a lightweight mode for small tasks.

## GitHub Repo Description

Codex-native factory workflow, routing skills, safety checks, upgrade tooling, and templates for staged execution

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

- `factory-router` for task routing and model-fit guidance
- `freeze` + `guard` for narrow-scope safety checks
- `factory-kit-upgrade` for local version reporting, published-release checks, safe refresh, and downgrade protection
- repo-local working memory in `.codex/context/`
- staged execution instead of one-shot prompting
- structured review gates
- runtime QA evidence
- release + retro artifacts
- a lightweight mode for small tasks

Repo:

https://github.com/kevintseng/codex-factory-kit

## X Post

I open-sourced `codex-factory-kit`, a workflow layer for using Codex on real repos.

It adds:

- `factory-router` for task routing and model-fit guidance
- `freeze` + `guard` for narrow-scope safety checks
- `factory-kit-upgrade` for local version reporting, published-release checks, safe refresh, and downgrade protection
- repo-local working memory in `.codex/context/`
- staged execution instead of one-shot prompting
- review gates
- runtime QA evidence
- release + retro artifacts
- a lightweight mode for small tasks

Repo:
https://github.com/kevintseng/codex-factory-kit

## LinkedIn / GitHub Post

I open-sourced `codex-factory-kit`, a Codex-native workflow layer for real repositories.

The goal is simple: make Codex behave less like a stateless prompt loop and more like a staged engineering workflow.

It includes:

- a shipped `factory-router` skill for lightweight vs full-loop classification and model-fit guidance
- a shipped safety layer with `freeze` and `guard` for narrow-scope risky changes
- a shipped `factory-kit-upgrade` skill for local version reporting, published-release checks, safe refresh, and downgrade protection
- global Codex skills for planning, review, QA, release notes, and retros
- repo-local working memory in `.codex/context/`
- reusable templates for `PRODUCT.md`, `PLAN.md`, `TESTPLAN.md`, `REVIEW.jsonl`, `RELEASE.md`, and `RETRO.md`
- a lightweight mode for smaller tasks

Repo:
https://github.com/kevintseng/codex-factory-kit

## Traditional Chinese Post

我把最近整理的 Codex enhancement 公開成一個 repo 了：

`codex-factory-kit`
https://github.com/kevintseng/codex-factory-kit

我想解的問題很直接：
很多 AI coding workflow 都太依賴單次 prompt，結果每個 session 都在重建上下文。

這個 repo 做的事是把 Codex 工作流拆成幾個可持續的階段：

- bootstrap context
- factory router
- freeze / guard safety layer
- sharpen the problem
- plan execution
- implement with repo-local agents
- review gate
- runtime QA
- document release
- retro

另外也有 lightweight mode，所以小任務不用每次都跑完整流程。

## Longer Post

I wanted a better way to use Codex on real projects than just stacking prompts and hoping context survives.

So I packaged the workflow layer I have been using into a public repo:

`codex-factory-kit`

What it does:

- adds a shipped `factory-router` skill for lightweight vs full-loop classification and model-fit guidance
- adds shipped `freeze` and `guard` skills for narrow-scope risky changes
- adds a shipped `factory-kit-upgrade` skill for local version reporting, published-release checks, safe refresh, and downgrade protection
- adds global Codex skills for planning, review, QA, release notes, and retros
- adds reusable templates for `PRODUCT.md`, `PLAN.md`, `TESTPLAN.md`, `REVIEW.jsonl`, `RELEASE.md`, and `RETRO.md`
- keeps project-specific agents local to each repo
- supports a lightweight mode so small tasks do not feel process-heavy

The goal is simple: make Codex work more like a software factory and less like a stateless prompt loop.

Repo:

https://github.com/kevintseng/codex-factory-kit
