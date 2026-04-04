# Codex Factory Kit

Codex Factory Kit 是一套给 Codex 使用的工作流层，适合不想只靠零散 prompt 工作的人。

Languages: [English](README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md)

它让 Codex 不再只是一次性提示，而是以分阶段方式完成工作，并且新增了一个可在实现前先选路径的 `factory-router`、一个用来缩小 blast radius 的 safety layer，以及一个可沉淀可复用经验的 learning layer。

较大的任务会走这条流程：

1. bootstrap context
2. 路由任务
3. 澄清问题
4. 规划执行
5. 必要时先 freeze scope
6. 用 repo-local agents 实现
7. 用 guard 检查 diff 是否越界
8. 用结构化 review 做 gate
9. 在运行时验证
10. 更新 release notes 和文档
11. 编写 retro
12. 将可复用的 learnings 提升成持久 guidance

同时也提供轻量模式，让小任务不需要每次都走完整流程。

## 适合谁

如果你符合以下情况，这套会很有用：

- 你是在真实 repo 中使用 Codex，而不是玩具示例
- 你希望 planning、review、QA、documentation 能跨 session 累积，而不是每次重来
- 你想把 repo-local working memory 放在 `.codex/context/`
- 你希望小任务保持快速，大任务则更稳定

如果你的工作几乎都是极小的一文件修补，而且不想保留任何工作流 artifact，那这套可能偏重。

## 核心理念

大多数 AI coding 配置都会遇到同一个问题：每一轮都要重新构建整个任务上下文。

Codex Factory Kit 的做法，是在每个 repo 中加入可持续存在的 artifact：

- `PRODUCT.md`
- `PLAN.md`
- `TESTPLAN.md`
- `REVIEW.jsonl`
- `RELEASE.md`
- `RETRO.md`
- `LEARNINGS.jsonl`
- 需要时加入 `FREEZE.md`

这样可以得到：

- 更好的多 session 连续性
- 主代理与子代理之间更清晰的交接
- 明确的 review 与 QA 证据
- 更少的重复说明

## 工作流长什么样

```text
模糊任务
  -> factory-router
  -> office-hours-codex
  -> PRODUCT.md
  -> sprint-conductor
  -> PLAN.md + TESTPLAN.md
  -> optional freeze
  -> implementation
  -> optional guard
  -> review-gate
  -> qa-runtime
  -> document-release
  -> retro
  -> optional learn
```

## 包含什么

- 给 Codex 的全局 skills：
  - `bootstrap-context`
  - `factory-router`
  - `factory-kit-upgrade`
  - `freeze`
  - `guard`
  - `learn`
  - `office-hours-codex`
  - `sprint-conductor`
  - `review-gate`
  - `qa-runtime`
  - `document-release`
  - `retro`
- factory templates：
  - `PRODUCT.md`
  - `PLAN.md`
  - `TESTPLAN.md`
  - `REVIEW.jsonl.example`
  - `RELEASE.md`
  - `RETRO.md`
  - `LEARNINGS.jsonl.example`
  - `FREEZE.md`
- 一份建议使用的全局 `AGENTS.md` policy
- 一个将 skills 与 templates 复制到 `~/.codex` 的安装脚本

## 为什么这样做

核心原因很简单：持久化的 artifact 比每次重新解释任务更有效。

不要让 Codex 每次都只依赖短期上下文记住整个项目，而是把工作中的 artifact 放在 repo 内的 `.codex/context/`：

- `PRODUCT.md`
- `PLAN.md`
- `TESTPLAN.md`
- `REVIEW.jsonl`
- `RELEASE.md`
- `RETRO.md`
- `LEARNINGS.jsonl`

这会让交接、review、QA 和后续工作稳定很多。

## 安装

先把 repo clone 下来，然后执行：

```bash
./install.sh
```

这会安装：

- `skills/*` 到 `~/.codex/skills/`
- `templates/factory/*` 到 `~/.codex/templates/factory/`
- `AGENTS.md` 到 `~/.codex/AGENTS.factory-kit.md`
- `VERSION` 与 `CHANGELOG.md` 到 `~/.codex/factory-kit/`

安装程序不会覆盖你现有的 `~/.codex/AGENTS.md`。

如果你想把建议的全局 policy 变成默认工作方式，可以手动应用：

```bash
cp ~/.codex/AGENTS.factory-kit.md ~/.codex/AGENTS.md
```

只有在你确实想让这套 workflow 成为 Codex 默认操作模式时才这样做。

## Quick Start

1. 安装这套工具：

```bash
git clone https://github.com/kevintseng/codex-factory-kit.git
cd codex-factory-kit
./install.sh
```

2. 如有需要，采用建议的全局 policy：

```bash
cp ~/.codex/AGENTS.factory-kit.md ~/.codex/AGENTS.md
```

3. 在你关心的 repo 中初始化本地工作记忆：

```bash
mkdir -p .codex/context
cp ~/.codex/templates/factory/PLAN.md .codex/context/PLAN.md
printf '\n.codex/context/\n' >> .gitignore
```

4. 小任务走轻量模式，风险更高或多步骤任务走完整流程。

对于非 trivial 的任务，建议先用 `factory-router` 来判断：

- 该走 lightweight mode 还是 full mode
- 需要哪些后续 skills
- lead / worker 应采用什么 model-fit
- 是否需要 `freeze` / `guard` 来缩小 blast radius

如果你要查看已安装版本，或把 `~/.codex` 里的 kit 刷新成当前 repo checkout 的内容，可以执行：

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh status
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh upgrade
```

## 每个 Repo 的采用方式

在 repo 内初始化：

```bash
mkdir -p .codex/context
cp ~/.codex/templates/factory/PRODUCT.md .codex/context/PRODUCT.md
cp ~/.codex/templates/factory/PLAN.md .codex/context/PLAN.md
cp ~/.codex/templates/factory/TESTPLAN.md .codex/context/TESTPLAN.md
cp ~/.codex/templates/factory/RELEASE.md .codex/context/RELEASE.md
cp ~/.codex/templates/factory/RETRO.md .codex/context/RETRO.md
: > .codex/context/REVIEW.jsonl
: > .codex/context/LEARNINGS.jsonl
printf '\n.codex/context/\n' >> .gitignore
```

你也可以用 `bootstrap-context` skill 渐进式地创建这些文件，而不覆盖已有 artifact。

## 示例任务流程

例子：你让 Codex 修一个不稳定的 checkout route。

没有 workflow layer 的情况下：

- agent 可能直接开始 patch code
- tests 和 runtime verification 可能隐含或被跳过
- 下一个 session 必须重新拼凑改了什么、哪些地方仍有风险

使用 Codex Factory Kit：

1. `sprint-conductor` 先写出明确的 `PLAN.md`
2. `review-gate` 把 findings 记录到 `REVIEW.jsonl`
3. `qa-runtime` 把实际验证证据记录到 `TESTPLAN.md`
4. `document-release` 在行为改变时更新 release notes
5. `retro` 记录拖慢工作的因素
6. `learn` 把可复用的经验提升进 `LEARNINGS.jsonl`
7. 下一次遇到相似任务时，用 `learn sync-context` 把相关 guidance 写回 `PLAN.md` 与 `TESTPLAN.md`

更多示例请看 [docs/examples.md](docs/examples.md)。

## Factory Router

`factory-router` 是当前公开 kit 中第一个正式 shipped 的 vNext 能力。

它会在实现前先帮你决定：

- 该走 lightweight mode 还是 full mode
- 是否需要 `office-hours-codex`、`review-gate`、`qa-runtime`、`document-release`、`retro`
- 是否需要用 `freeze` / `guard` 把高风险工作锁在狭窄范围内
- 工作应该保持在本地 critical path，还是可以拆成 bounded parallel slices
- 哪一种 model class 应该主导路由、集成与 gate，哪一种可以安全执行 bounded work

这属于 soft orchestration，不是隐藏式自动化。它是在帮助 Codex 选对流程和质量门槛，而不是声称平台级拦截或自动执行危险操作。

## Freeze 与 Guard

目前 kit 也提供基础 safety layer：

- `freeze` 会建立 `.codex/context/FREEZE.md`，定义 allowed paths、blocked paths 与 protected invariants
- `guard` 会在最终 gate 前检查当前 diff 是否符合这份 freeze contract

这适合大型 repo 里“高风险但范围刻意很小”的工作，不是每个小修补都要用。

## Learning Layer

当前 kit 也提供第一层 learning layer：

- `learn` 可以把可复用的 guidance 写入 `.codex/context/LEARNINGS.jsonl`
- learnings store 是 repo-local，并且可以跨任务持续使用
- 可以列出、推荐与新任务相关的 learnings、同步进 planning artifacts，也可以停用过时 guidance

这不是随意堆积的记忆，而是会影响后续 routing、review、QA、release、safety 决策的可复用 guidance。

当新任务符合既有 guidance 时，可用：

```bash
python3 ~/.codex/skills/learn/scripts/factory-kit-learn.py sync-context \
  --task-class ui_workflow \
  --tag browser
```

这会刷新 `.codex/context/PLAN.md` 与 `.codex/context/TESTPLAN.md` 里的 `Relevant Learnings` 区块。

## Versioning、Release Check 与 Upgrade

当前 kit 已经内建本地升级基础，以及第一层 release-check 能力：

- repo 根目录的 `VERSION`
- repo 根目录的 `CHANGELOG.md`
- 安装到 `~/.codex/factory-kit/` 的 metadata
- `factory-kit-upgrade` skill 与脚本

它目前可以：

- 回报 repo 版本与已安装版本
- 比较本地版本与最新已发布的 GitHub release
- 把 update-check 状态写到 `~/.codex/factory-kit/update-state.json`
- 检测所选 `CODEX_HOME`
- 在可用时重用 install metadata 中记录的 source checkout 路径
- 从当前 repo checkout 刷新已安装的 skill pack 与 templates

它目前还不会：

- 未经指令就自动升级
- 主动提醒或 snooze update checks
- 重写 repo-local `.codex/context/` artifact
- 覆盖 `~/.codex/AGENTS.md`

如果你只想检查最新已发布版本，而不改动安装内容，可以执行：

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
```

如果当前 repo checkout 比已安装版本更旧，`upgrade` 会默认拒绝覆盖，只有明确加上 `--allow-downgrade` 才会执行。

## 默认流程

当任务是多步骤、高风险、或涉及多个 surface 时，使用完整流程：

1. `bootstrap-context`
2. 路径不明确时先用 `factory-router`
3. 对模糊需求先用 `office-hours-codex`
4. 需要缩小 blast radius 时先用 `freeze`
5. `sprint-conductor`
6. 用 repo-local agents 实现
7. 如果有 freeze contract，就先跑 `guard`
8. `review-gate`
9. `qa-runtime`
10. `document-release`
11. `retro`

## 轻量模式

当以下条件都成立时，使用轻量模式：

- 变更小且边界明确
- 不明显需要浏览器或多 surface 验证
- 不涉及 infra、migration、legal、security 或 fintech 风险

在轻量模式中：

1. 除非需求仍然模糊，否则跳过 `office-hours-codex`
2. 只用 `sprint-conductor` 更新 `PLAN.md`
3. 除非任务扩大，否则跳过 `TESTPLAN.md`、`RELEASE.md`、`RETRO.md`
4. 对非常小的本地改动，除非风险上升，否则可跳过 `review-gate`

## Repo-Local Agents

这个 repo 不会附带你各项目自己的 specialist packs。

建议模型是：

- 共享 workflow skills 放在 `~/.codex/skills/`
- 项目特定 agents 放在 `<repo>/.codex/agents/`
- 工作记忆放在 `<repo>/.codex/context/`

这样就能公开可复用的 operating model，同时不泄露私人项目上下文。

## 为公开分享而设计

这个 repo 刻意不包含：

- 私人项目 prompt
- repo-local 的领域 agent packs
- 个人 logs、sessions、auth 或 Codex state
- 私有 repo 中任何 app-specific 代码

它只包含可复用的 workflow layer。

## 目录结构

```text
.
├── VERSION
├── CHANGELOG.md
├── AGENTS.md
├── install.sh
├── skills/
│   ├── bootstrap-context/
│   ├── factory-router/
│   ├── factory-kit-upgrade/
│   ├── freeze/
│   ├── guard/
│   ├── office-hours-codex/
│   ├── sprint-conductor/
│   ├── review-gate/
│   ├── qa-runtime/
│   ├── document-release/
│   └── retro/
├── docs/
│   ├── adoption.md
│   ├── examples.md
│   └── share.md
└── templates/
    └── factory/
        └── FREEZE.md
```

## 文档

- [Adoption notes](docs/adoption.md)
- [Usage examples](docs/examples.md)
- [Share copy](docs/share.md)

## License

MIT
