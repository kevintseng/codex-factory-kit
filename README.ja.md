# Codex Factory Kit

Codex Factory Kit は、単発のプロンプト集ではなく、継続的な作業フローとして Codex を使いたい人向けのワークフローレイヤーです。

Languages: [English](README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md)

Codex を一回限りの指示実行ではなく、段階的な実行モデルで動かせるようにし、実装前に経路を選ぶ `factory-router`、危険な編集の blast radius を狭く保つ safety layer、そして再利用できる運用知見を残す learning layer を提供します。

大きめのタスクでは、次の流れを使います。

1. bootstrap context
2. タスクのルーティング
3. 問題の明確化
4. 実行計画
5. 必要なら先に scope を freeze
6. repo-local agents で実装
7. frozen boundary に対して diff を guard
8. 構造化された review でゲート
9. 実行時検証
10. release notes とドキュメント更新
11. retro の記録
12. 再利用すべき learnings の昇格

小さなタスク向けには、毎回フルプロセスを回さなくてよい lightweight mode もあります。

## どんな人向けか

次に当てはまるなら有効です。

- Codex を実際の repo で使っている
- planning、review、QA、documentation を session をまたいで蓄積したい
- `.codex/context/` に repo-local working memory を置きたい
- 小さなタスクは速く、大きなタスクは安定させたい

作業のほとんどがごく小さな 1 ファイル修正で、永続的な workflow artifact が不要なら、少し重いかもしれません。

## コアアイデア

多くの AI coding 環境は、毎ターンごとにタスク全体の前提を作り直してしまう、という同じ問題を抱えています。

Codex Factory Kit は、各 repo に持続的な artifact を置くことでそれを改善します。

- `PRODUCT.md`
- `PLAN.md`
- `TESTPLAN.md`
- `REVIEW.jsonl`
- `RELEASE.md`
- `RETRO.md`
- `LEARNINGS.jsonl`
- 危険な変更の範囲を固定したいときの `FREEZE.md`

これにより次が得られます。

- 複数 session 間の連続性向上
- メインエージェントとサブエージェント間の引き継ぎ整理
- review と QA の明示的な証拠
- 繰り返し説明の削減

## ワークフローの形

```text
曖昧な依頼
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

## 含まれているもの

- Codex 用のグローバル skills:
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
- factory templates:
  - `PRODUCT.md`
  - `PLAN.md`
  - `TESTPLAN.md`
  - `REVIEW.jsonl.example`
  - `RELEASE.md`
  - `RETRO.md`
  - `LEARNINGS.jsonl.example`
  - `FREEZE.md`
- 推奨されるグローバル `AGENTS.md` policy
- `~/.codex` に skills と templates をコピーする installer

## なぜ必要か

要点は単純です。毎回タスクを言い直すより、持続する artifact の方が強いからです。

Codex に毎回短期コンテキストだけでプロジェクト全体を覚えさせるのではなく、repo 内の `.codex/context/` に作業 artifact を置きます。

- `PRODUCT.md`
- `PLAN.md`
- `TESTPLAN.md`
- `REVIEW.jsonl`
- `RELEASE.md`
- `RETRO.md`
- `LEARNINGS.jsonl`

これにより、引き継ぎ、review、QA、継続作業がかなり安定します。

## インストール

repo を clone して、次を実行します。

```bash
./install.sh
```

これにより次がインストールされます。

- `skills/*` -> `~/.codex/skills/`
- `templates/factory/*` -> `~/.codex/templates/factory/`
- `AGENTS.md` -> `~/.codex/AGENTS.factory-kit.md`
- `VERSION` と `CHANGELOG.md` -> `~/.codex/factory-kit/`

installer は既存の `~/.codex/AGENTS.md` を上書きしません。

この workflow をデフォルトにしたい場合だけ、手動で適用してください。

```bash
cp ~/.codex/AGENTS.factory-kit.md ~/.codex/AGENTS.md
```

## Quick Start

1. キットをインストールします。

```bash
git clone https://github.com/kevintseng/codex-factory-kit.git
cd codex-factory-kit
./install.sh
```

2. 必要なら推奨グローバル policy を適用します。

```bash
cp ~/.codex/AGENTS.factory-kit.md ~/.codex/AGENTS.md
```

3. 対象 repo でローカル working memory を初期化します。

```bash
mkdir -p .codex/context
cp ~/.codex/templates/factory/PLAN.md .codex/context/PLAN.md
printf '\n.codex/context/\n' >> .gitignore
```

4. 小さなタスクには lightweight mode、複雑または高リスクなタスクには full loop を使います。

非 trivial なタスクでは、まず `factory-router` で次を判定するのが推奨です。

- lightweight mode か full mode か
- どの follow-up skill が必要か
- lead / worker にどの model-fit を使うべきか
- blast radius を狭く保つために `freeze` / `guard` が必要か

インストール済みバージョンの確認や、現在の repo checkout から `~/.codex` の kit を更新したい場合は次を実行します。

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh status
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh upgrade
```

## Repo ごとの導入

repo 内で初期化する例：

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

既存 artifact を壊さずに段階的に作るなら `bootstrap-context` skill も使えます。

## タスクフロー例

例: Codex に不安定な checkout route の修正を依頼する場合。

workflow layer がないと:

- agent がすぐに code patch に入るかもしれない
- tests や runtime verification が暗黙のまま省略されるかもしれない
- 次の session で何が変わり何がリスクなのかを再構築し直す必要がある

Codex Factory Kit を使うと:

1. `sprint-conductor` が具体的な `PLAN.md` を書く
2. `review-gate` が findings を `REVIEW.jsonl` に記録する
3. `qa-runtime` が実行時検証の証拠を `TESTPLAN.md` に残す
4. `document-release` が必要なら release notes を更新する
5. `retro` が何が作業を遅くしたかを残す
6. `learn` が再利用できる教訓を `LEARNINGS.jsonl` に昇格する
7. 次の類似タスクでは `learn sync-context` で関連 guidance を `PLAN.md` と `TESTPLAN.md` に戻す

より具体的な例は [docs/examples.md](docs/examples.md) を参照してください。

## Factory Router

`factory-router` は、公開 kit に入った最初の正式な vNext capability です。

実装前に次を判断します。

- lightweight mode か full mode か
- `office-hours-codex`、`review-gate`、`qa-runtime`、`document-release`、`retro` が必要か
- 危険な作業を狭い範囲に閉じ込めるために `freeze` / `guard` を使うべきか
- 作業をローカルの critical path に残すべきか、bounded parallel slices に分けられるか
- どの model class がルーティング、統合、ゲートを主導し、どの class が bounded work を安全に実行できるか

これは hidden automation ではなく soft orchestration です。Codex に正しい workflow と quality bar を選ばせるためのものであり、危険な操作をプラットフォームレベルで自動実行すると主張するものではありません。

## Freeze And Guard

kit には基本的な safety layer も含まれます。

- `freeze` は allowed paths、blocked paths、protected invariants を持つ `.codex/context/FREEZE.md` を作ります
- `guard` は最終ゲート前に現在の diff がその freeze contract を守ったかを検証します

これは大きな repo で「高リスクだが範囲は小さく保ちたい」作業向けであり、すべての小修正に必要なものではありません。

## Learning Layer

kit には最初の learning layer も含まれます。

- `learn` は再利用できる guidance を `.codex/context/LEARNINGS.jsonl` に昇格します
- learning store は repo-local で、タスクをまたいで使い回せます
- 新しいタスク向けに relevant な learning を参照したり、planning artifact に反映したり、古くなった guidance を無効化できます

これは自由形式のメモ置き場ではありません。今後の routing、review、QA、release、safety の判断を変えるための再利用可能な guidance です。

新しいタスクが既存の guidance に合う場合は、次を使えます。

```bash
python3 ~/.codex/skills/learn/scripts/factory-kit-learn.py sync-context \
  --task-class ui_workflow \
  --tag browser
```

これにより `.codex/context/PLAN.md` と `.codex/context/TESTPLAN.md` の `Relevant Learnings` セクションが更新されます。

## Versioning、Release Check、Upgrade

kit にはローカル upgrade foundation と最初の release-check layer も含まれます。

- repo ルートの `VERSION`
- repo ルートの `CHANGELOG.md`
- `~/.codex/factory-kit/` に入る installed metadata
- `factory-kit-upgrade` skill と script

現時点でできること:

- repo version と installed version の表示
- ローカル version と最新の公開 GitHub release の比較
- `~/.codex/factory-kit/update-state.json` への update-check state の保存
- 対象 `CODEX_HOME` の検出
- 利用可能なら install metadata に保存された source checkout path の再利用
- 現在の repo checkout から installed skill pack と templates を更新

現時点でまだしないこと:

- 明示コマンドなしの自動 upgrade
- proactive な update prompt や snooze
- repo-local `.codex/context/` artifact の書き換え
- `~/.codex/AGENTS.md` の上書き

install を変更せずに最新の公開 version だけ確認したいなら、次を実行します。

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
```

現在の repo checkout が installed version より古い場合、`upgrade` はデフォルトで上書きを拒否し、実行には明示的な `--allow-downgrade` が必要です。

## デフォルトループ

タスクが多段階、高リスク、または複数 surface にまたがる場合は full loop を使います。

1. `bootstrap-context`
2. 経路が明確でないなら `factory-router`
3. 要件が曖昧なら `office-hours-codex`
4. blast radius を狭く保つ必要があるなら `freeze`
5. `sprint-conductor`
6. repo-local agents による実装
7. freeze contract があるなら `guard`
8. `review-gate`
9. `qa-runtime`
10. `document-release`
11. `retro`

## Lightweight Mode

次がすべて当てはまるなら lightweight mode を使います。

- 変更が小さく境界が明確
- browser や multi-surface verification が明らかに不要
- infra、migration、legal、security、fintech のリスクがない

lightweight mode では:

1. 依頼が曖昧でない限り `office-hours-codex` を省略
2. `sprint-conductor` で `PLAN.md` だけ更新
3. タスクが膨らまない限り `TESTPLAN.md`、`RELEASE.md`、`RETRO.md` を省略
4. ごく小さな変更では、リスクが上がらない限り `review-gate` を省略

## Repo-Local Agents

この repo には、あなたの各プロジェクト固有の specialist pack は含みません。

意図している分離は次の通りです。

- 共通 workflow skills は `~/.codex/skills/`
- project-specific agents は `<repo>/.codex/agents/`
- working memory は `<repo>/.codex/context/`

この分離によって、私的なプロジェクト文脈を漏らさずに再利用可能な operating model だけを公開できます。

## 公開前提の設計

この repo には意図的に次を含めていません。

- private project prompts
- repo-local domain agent packs
- personal logs、sessions、auth、Codex state
- private repo の app-specific code

含まれているのは再利用可能な workflow layer だけです。

## ディレクトリ構成

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

## ドキュメント

- [Adoption notes](docs/adoption.md)
- [Usage examples](docs/examples.md)
- [Share copy](docs/share.md)

## License

MIT
