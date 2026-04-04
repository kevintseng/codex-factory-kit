# Share Copy

## One-Line Description

Codex Factory Kit is an open-source workflow kit for the Codex community: staged execution, repo-local working memory, review gates, QA evidence, and lightweight mode for small tasks.

## GitHub Repo Description

Open-source workflow kit for using Codex well on real repos

## GitHub Topics

- codex
- openai
- codex-community
- ai-coding
- agent-workflow
- developer-tools
- prompt-engineering
- software-factory
- review-automation
- qa-automation
- ai-agents

## Short Post

I open-sourced `codex-factory-kit` as a contribution to the Codex community.

It is a workflow kit for using Codex on real repos with:

- repo-local working memory in `.codex/context/`
- staged execution instead of one-shot prompting
- structured review gates
- runtime QA evidence
- release + retro artifacts
- a lightweight mode for small tasks

Repo:

https://github.com/kevintseng/codex-factory-kit

## X Post

I open-sourced `codex-factory-kit` as a contribution to the Codex community.

It is a workflow kit for using Codex on real repos with:

- repo-local working memory in `.codex/context/`
- staged execution instead of one-shot prompting
- review gates
- runtime QA evidence
- release + retro artifacts
- a lightweight mode for small tasks

Repo:
https://github.com/kevintseng/codex-factory-kit

## LinkedIn / GitHub Post

I open-sourced `codex-factory-kit` as a contribution to the Codex community.

The goal is simple: help people use Codex on real repositories with a clearer operating model than a loose collection of prompts.

It includes:

- global Codex skills for planning, review, QA, release notes, and retros
- repo-local working memory in `.codex/context/`
- reusable templates for `PRODUCT.md`, `PLAN.md`, `TESTPLAN.md`, `REVIEW.jsonl`, `RELEASE.md`, and `RETRO.md`
- a lightweight mode for smaller tasks

It is not trying to replace Codex platform primitives. It is a community-built layer for using them more deliberately.

Repo:
https://github.com/kevintseng/codex-factory-kit

## Traditional Chinese Post

我把最近整理的 Codex workflow 經驗公開成一個 repo，當作對 Codex community 的一個貢獻：

`codex-factory-kit`
https://github.com/kevintseng/codex-factory-kit

我想解的問題很直接：
很多人在真實 repo 裡使用 Codex 時，還是太依賴單次 prompt，結果每個 session 都在重建上下文。

這個 repo 做的事，是把使用 Codex 的工作流整理成幾個可持續的階段：

- bootstrap context
- sharpen the problem
- plan execution
- implement with repo-local agents
- review gate
- runtime QA
- document release
- retro

另外也有 lightweight mode，所以小任務不用每次都跑完整流程。

它不是要重做 Codex 平台，而是希望提供一套社群可以直接採用、fork、延伸的 workflow kit。

## Longer Post

I wanted a better way to use Codex on real projects than just stacking prompts and hoping context survives.

So I packaged the workflow layer I have been using into a public repo as a contribution to the Codex community:

`codex-factory-kit`

What it does:

- adds global Codex skills for planning, review, QA, release notes, and retros
- adds reusable templates for `PRODUCT.md`, `PLAN.md`, `TESTPLAN.md`, `REVIEW.jsonl`, `RELEASE.md`, and `RETRO.md`
- keeps project-specific agents local to each repo
- supports a lightweight mode so small tasks do not feel process-heavy

The goal is simple: help Codex builders adopt a workflow that is easier to reuse, discuss, and improve together.

It is not an attempt to replace Codex primitives. It is a community-built layer for using them more intentionally on real repos.

Repo:

https://github.com/kevintseng/codex-factory-kit
