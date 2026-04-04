# Codex Factory Kit

Codex Factory Kit 是一套給 Codex 用的工作流程層，適合不想只靠零散 prompt 工作的人。

Languages: [English](README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md)

它讓 Codex 不再只是一次性提示，而是用分階段的方式完成工作，並且多了一個可在實作前先選路徑的 `factory-router`，以及用來縮小 blast radius 的 safety layer。

較大的任務會走這條流程：

1. bootstrap context
2. 路由任務
3. 釐清問題
4. 規劃執行
5. 必要時先 freeze scope
6. 用 repo-local agents 實作
7. 用 guard 檢查 diff 是否越界
8. 以結構化 review 做 gate
9. 在執行時驗證
10. 更新 release notes 與文件
11. 撰寫 retro

另外也提供輕量模式，讓小任務不需要每次都付出完整流程成本。

## 適合誰

如果你符合以下情況，這套會很有用：

- 你是在真實 repo 裡使用 Codex，不只是玩具範例
- 你希望 planning、review、QA、documentation 能在多次 session 中累積，而不是每次重來
- 你想把 repo-local working memory 放在 `.codex/context/`
- 你希望小任務維持快速，大任務則更穩定

如果你的工作幾乎都是極小的一檔修補，而且不想保留任何工作流程 artifact，那這套可能偏重。

## 核心概念

多數 AI coding 設定都會遇到同一個問題：每一輪都要重新重建整個任務脈絡。

Codex Factory Kit 的做法，是在每個 repo 裡加入可持續存在的 artifact：

- `PRODUCT.md`
- `PLAN.md`
- `TESTPLAN.md`
- `REVIEW.jsonl`
- `RELEASE.md`
- `RETRO.md`
- 需要時加入 `FREEZE.md`

這樣可以得到：

- 更好的多 session 連續性
- 主代理和子代理之間更乾淨的交接
- 明確的 review 與 QA 證據
- 更少的重複說明

## 工作流程長什麼樣子

```text
模糊任務
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
```

## 內容包含什麼

- 給 Codex 的全域 skills：
  - `bootstrap-context`
  - `factory-router`
  - `factory-kit-upgrade`
  - `freeze`
  - `guard`
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
  - `FREEZE.md`
- 一份建議用的全域 `AGENTS.md` policy
- 一個會把 skills 與 templates 複製進 `~/.codex` 的安裝腳本

## 為什麼這樣做

核心理由很簡單：可持續存在的 artifact，比每次重新解釋任務更有效。

不要讓 Codex 每次都只靠短期上下文記住整個專案，而是把工作中的 artifact 放在 repo 內的 `.codex/context/`：

- `PRODUCT.md`
- `PLAN.md`
- `TESTPLAN.md`
- `REVIEW.jsonl`
- `RELEASE.md`
- `RETRO.md`

這能讓交接、review、QA 和後續工作穩定很多。

## 安裝

先把 repo clone 下來，然後執行：

```bash
./install.sh
```

這會安裝：

- `skills/*` 到 `~/.codex/skills/`
- `templates/factory/*` 到 `~/.codex/templates/factory/`
- `AGENTS.md` 到 `~/.codex/AGENTS.factory-kit.md`
- `VERSION` 與 `CHANGELOG.md` 到 `~/.codex/factory-kit/`

安裝程式不會覆蓋你原本的 `~/.codex/AGENTS.md`。

如果你想把建議的全域 policy 變成預設工作方式，可以手動套用：

```bash
cp ~/.codex/AGENTS.factory-kit.md ~/.codex/AGENTS.md
```

只有在你真的想讓這套 workflow 成為 Codex 預設操作模式時才這樣做。

## Quick Start

1. 安裝這套工具：

```bash
git clone https://github.com/kevintseng/codex-factory-kit.git
cd codex-factory-kit
./install.sh
```

2. 如有需要，採用建議的全域 policy：

```bash
cp ~/.codex/AGENTS.factory-kit.md ~/.codex/AGENTS.md
```

3. 在你重視的 repo 裡初始化本地工作記憶：

```bash
mkdir -p .codex/context
cp ~/.codex/templates/factory/PLAN.md .codex/context/PLAN.md
printf '\n.codex/context/\n' >> .gitignore
```

4. 小任務走輕量模式，風險較高或多步驟任務走完整流程。

對於非 trivial 的任務，建議先用 `factory-router` 來判斷：

- 該走 lightweight mode 還是 full mode
- 需要哪些後續 skills
- lead / worker 應採用什麼 model-fit
- 是否需要 `freeze` / `guard` 來縮小 blast radius

如果你要查看已安裝版本，或把 `~/.codex` 內的 kit 刷新成目前 repo checkout 的內容，可以執行：

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh status
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh upgrade
```

## 每個 Repo 的採用方式

在 repo 內初始化：

```bash
mkdir -p .codex/context
cp ~/.codex/templates/factory/PRODUCT.md .codex/context/PRODUCT.md
cp ~/.codex/templates/factory/PLAN.md .codex/context/PLAN.md
cp ~/.codex/templates/factory/TESTPLAN.md .codex/context/TESTPLAN.md
cp ~/.codex/templates/factory/RELEASE.md .codex/context/RELEASE.md
cp ~/.codex/templates/factory/RETRO.md .codex/context/RETRO.md
: > .codex/context/REVIEW.jsonl
printf '\n.codex/context/\n' >> .gitignore
```

你也可以用 `bootstrap-context` skill 漸進式建立這些檔案，而不覆蓋既有 artifact。

## 範例任務流程

例子：你請 Codex 修一個不穩定的 checkout route。

沒有 workflow layer 的情況：

- agent 可能直接開始 patch code
- tests 和 runtime verification 可能隱含或被略過
- 下一個 session 必須重新拼湊改了什麼、哪些地方仍有風險

使用 Codex Factory Kit：

1. `sprint-conductor` 先寫出明確的 `PLAN.md`
2. `review-gate` 把 findings 記錄到 `REVIEW.jsonl`
3. `qa-runtime` 把實際驗證證據記錄到 `TESTPLAN.md`
4. `document-release` 在行為改變時更新 release notes
5. `retro` 記下拖慢工作的因素

更多範例請看 [docs/examples.md](docs/examples.md)。

## Factory Router

`factory-router` 是目前公開 kit 中第一個正式 shipped 的 vNext 能力。

它會在實作前先幫你決定：

- 該走 lightweight mode 還是 full mode
- 是否需要 `office-hours-codex`、`review-gate`、`qa-runtime`、`document-release`、`retro`
- 是否需要用 `freeze` / `guard` 把高風險工作鎖在狹窄範圍內
- 工作應該維持本地 critical path，還是能拆成 bounded parallel slices
- 哪一種 model class 應該主導路由、整合與 gate，哪一種可安全執行 bounded work

這是 soft orchestration，不是隱藏式自動化。它是在幫 Codex 選對流程與品質門檻，不是在宣稱平台層攔截或自動執行危險操作。

## Freeze 與 Guard

目前 kit 也提供基礎 safety layer：

- `freeze` 會建立 `.codex/context/FREEZE.md`，定義 allowed paths、blocked paths 與 protected invariants
- `guard` 會在最終 gate 前檢查目前 diff 是否符合這份 freeze contract

這適合大型 repo 裡「高風險但範圍刻意很小」的工作，不是每個小修補都要用。

## Versioning、Release Check 與 Upgrade

目前 kit 已經內建本地升級基礎，以及第一層 release-check 能力：

- repo 根目錄的 `VERSION`
- repo 根目錄的 `CHANGELOG.md`
- 安裝到 `~/.codex/factory-kit/` 的 metadata
- `factory-kit-upgrade` skill 與腳本

它目前可以：

- 回報 repo 版本與已安裝版本
- 比對本地版本與最新已發布的 GitHub release
- 把 update-check 狀態寫到 `~/.codex/factory-kit/update-state.json`
- 偵測選定的 `CODEX_HOME`
- 在可用時重用 install metadata 中記錄的 source checkout 路徑
- 從目前 repo checkout 刷新已安裝的 skill pack 與 templates

它目前還不會：

- 未經指令就自動升級
- 主動提醒或 snooze update checks
- 重寫 repo-local `.codex/context/` artifact
- 覆蓋 `~/.codex/AGENTS.md`

如果你只想檢查最新已發布版本，而不改動安裝內容，可以執行：

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
```

如果目前 repo checkout 比已安裝版本舊，`upgrade` 會預設拒絕覆蓋，必須明確加上 `--allow-downgrade` 才會執行。

## 預設流程

當任務是多步驟、高風險、或牽涉多個 surface 時，使用完整流程：

1. `bootstrap-context`
2. 路徑不明確時先用 `factory-router`
3. 對模糊需求先用 `office-hours-codex`
4. 需要縮小 blast radius 時先用 `freeze`
5. `sprint-conductor`
6. 用 repo-local agents 實作
7. 如果有 freeze contract，就先跑 `guard`
8. `review-gate`
9. `qa-runtime`
10. `document-release`
11. `retro`

## 輕量模式

當以下條件都成立時，使用輕量模式：

- 變更小而且邊界明確
- 不明顯需要瀏覽器或多 surface 驗證
- 不涉及 infra、migration、legal、security 或 fintech 風險

在輕量模式中：

1. 除非需求仍然模糊，否則跳過 `office-hours-codex`
2. 只用 `sprint-conductor` 更新 `PLAN.md`
3. 除非任務擴大，否則跳過 `TESTPLAN.md`、`RELEASE.md`、`RETRO.md`
4. 對於很小的本地變更，除非風險上升，否則可跳過 `review-gate`

## Repo-Local Agents

這個 repo 不會附帶你各專案自己的 specialist packs。

建議模型是：

- 共用 workflow skills 放在 `~/.codex/skills/`
- 專案特定 agents 放在 `<repo>/.codex/agents/`
- 工作記憶放在 `<repo>/.codex/context/`

這樣就能公開可重用的 operating model，而不會洩漏私人專案脈絡。

## 為公開分享而設計

這個 repo 刻意不包含：

- 私人專案 prompt
- repo-local 的領域 agent packs
- 個人 logs、sessions、auth 或 Codex state
- 私有 repo 中任何 app-specific 程式碼

它只包含可重用的 workflow layer。

## 目錄結構

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

## 文件

- [Adoption notes](docs/adoption.md)
- [Usage examples](docs/examples.md)
- [Share copy](docs/share.md)

## License

MIT
