# Codex Factory Kit

<div align="center">
  <img src="assets/factory-cover-product.svg" alt="Codex Factory Kit 封面" width="100%" style="max-width: 960px;" />
</div>

Codex Factory Kit 是一套给 Codex 用户的 workflow kit，适合在真实 repo 里工作、又不想每次都只靠“打一段 prompt 然后重建一次上下文”的人。

Languages: [English](README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md)

它会把一组 skills、templates，和一份建议使用的 `AGENTS.md` policy 安装到 `~/.codex/`，让 Codex 可以更明确地规划、验证、review，并把工作记忆留在 repo 里。

如果你主要只做极小的一文件修补，这套可能太重。如果你常做多步骤任务、需要 review / QA 证据、或工作会跨多个 session，这套就有价值。

## 30 秒看懂这是什么

- 它是什么：
  一套给 Codex 的 workflow kit，不是 app，不是 daemon，也不是 IDE plugin。
- 它会装什么：
  `~/.codex/skills/`、`~/.codex/templates/factory/`，以及 `~/.codex/AGENTS.factory-kit.md`。
- 它解决什么问题：
  Codex 常见问题是每次 session 都要重建上下文、planning 很隐性、QA/review 没留下清楚证据。这套是把这些流程明文化。
- 你实际会得到什么：
  Codex 可以在 repo 的 `.codex/context/` 里维护 `PLAN.md`、`TESTPLAN.md`、`REVIEW.jsonl`、`RELEASE.md`、`RETRO.md`、`LEARNINGS.jsonl` 等 artifact。

## 零手动新手上手（直接复制粘贴）

如果你没有开发经验，先按这三步做：

```bash
cd /path/to/codex-factory-kit
./quickstart.sh --repo /path/to/your/repo
```

这个命令会帮你自动做：

1. 若未安装则先安装 kit
2. 初始化目标 repo 的上下文
3. 输出第一句建议你对 Codex 说的话

如果你已经在目标 repo 目录里，改成：

```bash
cd /path/to/your/repo
/path/to/codex-factory-kit/quickstart.sh
```

要立刻启用建议 policy，补上 `--adopt-policy`：

```bash
./quickstart.sh --repo /path/to/your/repo --adopt-policy
```

如果 kit 已经装好，只需初始化，使用 `--skip-install`：

```bash
./quickstart.sh --repo /path/to/your/repo --skip-install
```

旗标重点：

- `--repo PATH`：目标 repo 是你指定的 PATH。
- 不写 `--repo`：目标 repo 是你当前所在目录。
- `--adopt-policy`：立即把建议 policy 写入 `~/.codex/AGENTS.md`。
- 不写 `--adopt-policy`：保留你现有的 `~/.codex/AGENTS.md`。

## 30 秒清单

```text
1) `cd /path/to/codex-factory-kit`
2) `./quickstart.sh --repo /path/to/your/repo`
3) 要立刻启用建议 policy 就加上 `--adopt-policy`
4) 目标 repo 就是当前文件夹时，省略 `--repo`
```

- `--repo PATH`：明确指定目标 repo 路径
- 不写 `--repo`：使用当前文件夹作为目标 repo
- `--adopt-policy`：立即覆盖 `~/.codex/AGENTS.md`
- 不写 `--adopt-policy`：保留现有的 `~/.codex/AGENTS.md`

## 你不用先学会内部文件结构

你不需要先懂 `.codex/context/`、隐藏文件夹、`AGENTS.md` 或 `gitignore` 才能开始用。

默认的一次上手路径应该是：

1. 安装这套 kit
2. 视情况决定要不要直接启用建议 policy
3. 在目标 repo 跑一个初始化命令
4. 对 Codex 说先规划再写码

## 什么情况下值得用

这套特别适合你，如果：

- 你是在真实 repo 中使用 Codex，而不是玩具示例
- 你希望实现前先有推荐路径，而不是直接开始 patch
- 你希望 planning、review、QA、documentation 能跨 session 累积，而不是每次重来
- 你希望高风险工作有更明确的 gate 与边界
- 你预期工作会跨多个 session

这套大概不值得用，如果：

- 每次都只是极小的一文件修补
- 你不想在 repo 里保留任何 workflow artifact
- 你只想让 Codex 快速改完就走

## 它到底改变了什么

没有这套 kit 的情况下，很多事都停留在隐性状态：

- 这次任务的范围是什么
- 做过哪些验证
- review 找到了什么
- 下次遇到同类问题应该记住什么

有这套 kit 后，Codex 可以把这些变成 repo-local artifact：

- `PRODUCT.md`：需求还模糊时，把问题讲清楚
- `PLAN.md`：执行计划
- `TESTPLAN.md`：验证范围与证据
- `REVIEW.jsonl`：review findings 与 gate 状态
- `RELEASE.md`：行为或 setup 变更
- `RETRO.md`：这次工作哪里卡、哪里浪费
- `LEARNINGS.jsonl`：之后同类任务还能复用的 guidance
- `FREEZE.md`：高风险小范围修改时锁定边界

## 选一种安装路径

先把 repo clone 下来，然后选一种：

- 只安装，不直接启用：

```bash
./install.sh
```

- 安装并直接启用建议 policy：

```bash
./install.sh --adopt-policy
```

这两种都会安装：

- `skills/*` 到 `~/.codex/skills/`
- `templates/factory/*` 到 `~/.codex/templates/factory/`
- `AGENTS.md` 到 `~/.codex/AGENTS.factory-kit.md`
- `VERSION` 与 `CHANGELOG.md` 到 `~/.codex/factory-kit/`

安全路径不会覆盖你原本的 `~/.codex/AGENTS.md`。
启用路径则会直接帮你把建议 policy 写进 `~/.codex/AGENTS.md`。

参数差异一行看懂：

- `./install.sh`：只安装 kit，不会更改你现有的 `~/.codex/AGENTS.md`。
- `./install.sh --adopt-policy`：安装并立即把建议 policy 写入 `~/.codex/AGENTS.md`，并作为默认配置启用。

如果你之后想确认目前安装了什么，可执行：

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh status
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
```

## 3 分钟上手

1. 安装这套工具：

```bash
git clone https://github.com/kevintseng/codex-factory-kit.git
cd codex-factory-kit
./install.sh --adopt-policy
```

如果你想先看过 policy 再决定，改用 `./install.sh`。

2. 到你要使用的 repo 里执行：

```bash
~/.codex/factory-kit/init-repo.sh
```

这会自动建立缺少的 context 文件，并帮你更新 `.gitignore`。

如果你现在不在目标 repo 目录，可改为 `~/.codex/factory-kit/init-repo.sh --repo /path/to/repo`。

这个 bootstrap 命令怎么选：

- 不带 `--repo`：在「当前目录」初始化。
- 带 `--repo /path/to/repo`：在指定路径初始化（适合在其他目录运行时）。

3. 在那个 repo 里打开 Codex，先说：

```text
先规划这个任务再开始写码。除非风险真的高，否则维持轻量流程。
```

4. 如果这个任务会改到用户流程，再补一句：

```text
这会影响 browser 或 runtime flow，完成前请实际验证。
```

如果你是第一次用这套，先停在这里就够了。先安装、初始化 repo，再让 Codex 先规划后动手。下面那些进阶段落，等任务变大或风险变高时再看。

## 日常最小用法

对小任务：

1. 先叫 Codex 规划再写码
2. 刷新 repo 里的 plan
3. 实作
4. 如果风险没升高，就不用补完整流程

对大任务或高风险任务：

1. repo 还没初始化就先跑 bootstrap
2. 叫 Codex 先判断这次任务该走哪种流程
3. 需求还模糊时先把问题讲清楚
4. 让 Codex 写 `PLAN.md` 和 `TESTPLAN.md`
5. 高风险小范围修改时可先锁边界
6. 实作
7. 必要时检查有没有越界
8. 结构化 review
9. 需要 runtime 或 browser 证据时再验证
10. 行为或 setup 改变时更新文档或 release note
11. `retro`
12. 必要时把可复用的经验留下来

进阶对照：

- 判断任务流程：`factory-router`
- 写计划：`sprint-conductor`
- 结构化 review：`review-gate`
- runtime 验证：`qa-runtime`

## 包含什么

- 给 Codex 的全局 skills：
  - `bootstrap-context`
  - `factory-router`
  - `factory-kit-upgrade`
  - `freeze`
  - `guard`
  - `founder-review`
  - `eng-review`
  - `design-review`
  - `security-review`
  - `release-review`
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
- 一个把 skills 与 templates 复制到 `~/.codex` 的安装脚本
- 位于 `docs/generated/` 下的 generated contract references

## 为什么会有这套流程

核心原因很简单：持久化的 artifact 比每次重新解释任务更有效。

不要让 Codex 每次都只依赖短期上下文记住整个项目，而是把工作中的 artifact 放在 repo 内的 `.codex/context/`。这样交接、review、QA 和后续工作会稳定很多。

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

## 每个 Repo 的采用方式

默认路径：

```bash
~/.codex/factory-kit/init-repo.sh
```

这会建立缺少的 repo-local artifact，而且不会覆盖已有内容。

进阶手动 fallback：

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

## Governance Role Packs

当前 kit 也提供一组叠加在 `review-gate` 之上的薄治理 overlays：

- `founder-review`
- `eng-review`
- `design-review`
- `security-review`
- `release-review`

它们不是新的主流程，只是在不同 ship 决策视角下增加的 review lens。

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
