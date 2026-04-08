# Codex Factory Kit

Codex Factory Kit 是一套給 Codex 使用者的 workflow kit，適合在真實 repo 裡工作、又不想每次都只靠「打一段 prompt 然後重建一次上下文」的人。

Languages: [English](README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md)

它會把一組 skills、templates，和一份建議用的 `AGENTS.md` policy 安裝到 `~/.codex/`，讓 Codex 可以用比較明確的方式規劃、驗證、review，並把工作記憶留在 repo 裡。

如果你主要只做極小的一檔修補，這套可能太重。如果你常做多步驟任務、需要 review / QA 證據、或工作會跨多個 session，這套就有價值。

## 30 秒看懂這是什麼

- 它是什麼：
  一套給 Codex 的 workflow kit，不是 app，不是 daemon，也不是 IDE plugin。
- 它會裝什麼：
  `~/.codex/skills/`、`~/.codex/templates/factory/`，以及 `~/.codex/AGENTS.factory-kit.md`。
- 它解決什麼問題：
  Codex 常見問題是每次 session 都要重建上下文、planning 很隱性、QA/review 沒留下清楚證據。這套是把這些流程明文化。
- 你實際會得到什麼：
  Codex 可以在 repo 的 `.codex/context/` 裡維護 `PLAN.md`、`TESTPLAN.md`、`REVIEW.jsonl`、`RELEASE.md`、`RETRO.md`、`LEARNINGS.jsonl` 等 artifact。

## 初學者上手（直接複製貼上）

不熟悉開發流程也能先照這步驟做：

```bash
cd /path/to/codex-factory-kit
./quickstart.sh --repo /path/to/your/repo
```

這個指令會幫你做：

1. 沒有安裝就幫你安裝 kit
2. 幫指定 repo 建立上下文
3. 幫你輸出第一句要對 Codex 說的話

如果你已經在目標 repo 目錄，改成：

```bash
cd /path/to/your/repo
/path/to/codex-factory-kit/quickstart.sh
```

要馬上啟用建議 policy，補上 `--adopt-policy`：

```bash
./quickstart.sh --repo /path/to/your/repo --adopt-policy
```

如果 kit 先安裝好了，只要初始化上下文，用 `--skip-install`：

```bash
./quickstart.sh --repo /path/to/your/repo --skip-install
```

旗標重點：

- `--repo PATH`：目標 repo 是你指定的 PATH。
- 不寫 `--repo`：目標 repo 是你目前所在的資料夾。
- `--adopt-policy`：立即把建議 policy 寫入 `~/.codex/AGENTS.md`。
- 不寫 `--adopt-policy`：保留你原本的 `~/.codex/AGENTS.md`。

## 30 秒清單

```text
1) `cd /path/to/codex-factory-kit`
2) `./quickstart.sh --repo /path/to/your/repo`
3) 想立刻啟用建議 policy 就加上 `--adopt-policy`
4) 目標 repo 是目前資料夾就不加 `--repo`
```

- `--repo PATH`：明確指定目標 repo 路徑
- 不寫 `--repo`：使用目前資料夾作為目標 repo
- `--adopt-policy`：立即覆蓋 `~/.codex/AGENTS.md`
- 不寫 `--adopt-policy`：保留既有的 `~/.codex/AGENTS.md`

## 你不用先學會內部檔案結構

你不需要先懂 `.codex/context/`、隱藏資料夾、`AGENTS.md` 或 `gitignore` 才能開始用。

預設的一次上手路徑應該是：

1. 安裝這套 kit
2. 視情況決定要不要直接啟用建議 policy
3. 在目標 repo 跑一個初始化命令
4. 對 Codex 說先規劃再寫碼

## 什麼情況值得用

這套特別適合你，如果：

- 你是在真實 repo 裡使用 Codex，不只是玩具範例
- 你希望實作前先有推薦路徑，而不是直接開始 patch
- 你希望 planning、review、QA、documentation 能在多次 session 中累積，而不是每次重來
- 你希望高風險工作有更明確的 gate 與邊界
- 你預期工作會跨多個 session

這套大概不值得用，如果：

- 每次都只是極小的一檔修補
- 你不想在 repo 裡保留任何 workflow artifact
- 你只想讓 Codex 快速改完就走

## 它到底改變了什麼

沒有這套 kit 的情況下，很多事都停留在隱性狀態：

- 這次任務的範圍是什麼
- 做過哪些驗證
- review 找到了什麼
- 下次遇到同類問題應該記住什麼

有這套 kit 後，Codex 可以把這些變成 repo-local artifact：

- `PRODUCT.md`：需求還模糊時，把問題講清楚
- `PLAN.md`：執行計畫
- `TESTPLAN.md`：驗證範圍與證據
- `REVIEW.jsonl`：review findings 與 gate 狀態
- `RELEASE.md`：行為或 setup 變更
- `RETRO.md`：這次工作哪裡卡、哪裡浪費
- `LEARNINGS.jsonl`：之後同類任務還能重用的 guidance
- `FREEZE.md`：高風險小範圍修改時鎖定邊界

## 選一種安裝路徑

先把 repo clone 下來，然後選一種：

- 只安裝，不直接啟用：

```bash
./install.sh
```

- 安裝並直接啟用建議 policy：

```bash
./install.sh --adopt-policy
```

這兩種都會安裝：

- `skills/*` 到 `~/.codex/skills/`
- `templates/factory/*` 到 `~/.codex/templates/factory/`
- `AGENTS.md` 到 `~/.codex/AGENTS.factory-kit.md`
- `VERSION` 與 `CHANGELOG.md` 到 `~/.codex/factory-kit/`

安全路徑不會覆蓋你原本的 `~/.codex/AGENTS.md`。
啟用路徑則會直接幫你把建議 policy 寫進 `~/.codex/AGENTS.md`，並作為預設的 Codex policy。

旗標差異一行看懂：

- `./install.sh`：只安裝 kit，不會修改你現有的 `~/.codex/AGENTS.md`。
- `./install.sh --adopt-policy`：安裝並立即將建議 policy 寫入 `~/.codex/AGENTS.md`，成為預設行為。

如果你之後想確認目前安裝了什麼，可執行：

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh status
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
```

## 3 分鐘上手

1. 安裝這套工具：

```bash
git clone https://github.com/kevintseng/codex-factory-kit.git
cd codex-factory-kit
./install.sh --adopt-policy
```

如果你想先看過 policy 再決定，改用 `./install.sh`。

2. 到你要使用的 repo 裡執行：

```bash
~/.codex/factory-kit/init-repo.sh
```

這會自動建立缺少的 context 檔案，並幫你更新 `.gitignore`。

如果你現在不在目標 repo 目錄，改用 `~/.codex/factory-kit/init-repo.sh --repo /path/to/repo`。

這個 bootstrap 指令的差別是：

- 不帶 `--repo`：在「你現在所在目錄」建立上下文。
- 帶 `--repo /path/to/repo`：在指定路徑建立上下文（適合你從其他目錄啟動時）。

3. 在那個 repo 裡打開 Codex，先說：

```text
先規劃這個任務再開始寫碼。除非風險真的高，否則維持輕量流程。
```

4. 如果這個任務會改到使用者流程，再補一句：

```text
這會影響 browser 或 runtime flow，完成前請實際驗證。
```

如果你是第一次用這套，先停在這裡就夠了。先安裝、初始化 repo，再叫 Codex 先規劃後動手。下面那些進階段落，等任務變大或風險變高時再看。

## 日常最小用法

對小任務：

1. 先叫 Codex 規劃再寫碼
2. 刷新 repo 裡的 plan
3. 實作
4. 若風險沒升高，就不用補完整流程

對大任務或高風險任務：

1. repo 還沒初始化就先跑 bootstrap
2. 叫 Codex 先判斷這次任務該走哪種流程
3. 需求還模糊時先把問題講清楚
4. 讓 Codex 寫 `PLAN.md` 和 `TESTPLAN.md`
5. 高風險小範圍修改時可先鎖邊界
6. 實作
7. 必要時檢查有沒有越界
8. 結構化 review
9. 需要 runtime 或 browser 證據時再驗證
10. 行為或 setup 改變時更新文件或 release note
11. `retro`
12. 必要時把可重複使用的經驗留下來

進階對照：

- 判斷任務流程：`factory-router`
- 寫計畫：`sprint-conductor`
- 結構化 review：`review-gate`
- runtime 驗證：`qa-runtime`

## 內容包含什麼

- 給 Codex 的全域 skills：
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
- 一份建議用的全域 `AGENTS.md` policy
- 一個會把 skills 與 templates 複製進 `~/.codex` 的安裝腳本
- 放在 `docs/generated/` 下的 generated contract references

## 為什麼會有這套流程

核心理由很簡單：可持續存在的 artifact，比每次重新解釋任務更有效。

不要讓 Codex 每次都只靠短期上下文記住整個專案，而是把工作中的 artifact 放在 repo 內的 `.codex/context/`。這樣交接、review、QA 和後續工作會穩定很多。

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
  -> optional learn
```

## 每個 Repo 的採用方式

預設路徑：

```bash
~/.codex/factory-kit/init-repo.sh
```

這會建立缺少的 repo-local artifact，而且不會覆蓋既有內容。

進階手動 fallback：

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
6. `learn` 把可重複使用的經驗提升進 `LEARNINGS.jsonl`
7. 下一次遇到相似任務時，用 `learn sync-context` 把相關 guidance 寫回 `PLAN.md` 與 `TESTPLAN.md`

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

## Governance Role Packs

目前 kit 也提供一組疊加在 `review-gate` 之上的薄治理 overlays：

- `founder-review`
- `eng-review`
- `design-review`
- `security-review`
- `release-review`

它們不是新的主流程，只是不同 ship 決策視角下的額外 review lens。

## Learning Layer

目前 kit 也提供第一層 learning layer：

- `learn` 可把可重複使用的 guidance 寫進 `.codex/context/LEARNINGS.jsonl`
- learnings store 是 repo-local，而且可跨任務持續使用
- 可以列出、推薦與新任務相關的 learnings、同步進 planning artifacts，也能停用過時 guidance

這不是自由格式的記憶傾倒，而是會影響後續 routing、review、QA、release、safety 決策的可重用 guidance。

當新任務符合既有 guidance 時，可用：

```bash
python3 ~/.codex/skills/learn/scripts/factory-kit-learn.py sync-context \
  --task-class ui_workflow \
  --tag browser
```

這會刷新 `.codex/context/PLAN.md` 與 `.codex/context/TESTPLAN.md` 裡的 `Relevant Learnings` 區塊。

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
