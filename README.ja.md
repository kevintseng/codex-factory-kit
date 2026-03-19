# Codex Factory Kit

Codex Factory Kit は、単発のプロンプト集ではなく、継続的な作業フローとして Codex を使いたい人向けのワークフローレイヤーです。

Languages: [English](README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md)

Codex を一回限りの指示実行ではなく、段階的な実行モデルで動かせるようにします。

大きめのタスクでは、次の流れを使います。

1. bootstrap context
2. 問題の明確化
3. 実行計画
4. repo-local agents で実装
5. 構造化された review でゲート
6. 実行時検証
7. release notes とドキュメント更新
8. retro の記録

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

これにより次が得られます。

- 複数 session 間の連続性向上
- メインエージェントとサブエージェント間の引き継ぎ整理
- review と QA の明示的な証拠
- 繰り返し説明の削減

## ワークフローの形

```text
曖昧な依頼
  -> office-hours-codex
  -> PRODUCT.md
  -> sprint-conductor
  -> PLAN.md + TESTPLAN.md
  -> implementation
  -> review-gate
  -> qa-runtime
  -> document-release
  -> retro
```

## 含まれているもの

- Codex 用のグローバル skills:
  - `bootstrap-context`
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

より具体的な例は [docs/examples.md](docs/examples.md) を参照してください。

## デフォルトループ

タスクが多段階、高リスク、または複数 surface にまたがる場合は full loop を使います。

1. `bootstrap-context`
2. 要件が曖昧なら `office-hours-codex`
3. `sprint-conductor`
4. repo-local agents による実装
5. `review-gate`
6. `qa-runtime`
7. `document-release`
8. `retro`

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
├── AGENTS.md
├── install.sh
├── skills/
│   ├── bootstrap-context/
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
```

## ドキュメント

- [Adoption notes](docs/adoption.md)
- [Usage examples](docs/examples.md)
- [Share copy](docs/share.md)

## License

MIT
