# Codex Factory Kit

Codex Factory Kit은 "프롬프트 하나 붙여 넣고 세션이 다 기억해 주길 바라는 방식"보다 더 반복 가능하게 Codex를 쓰고 싶은 사람을 위한 workflow pack입니다.

Languages: [English](README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md)

이 kit은 `~/.codex/` 아래에 skills, templates, 그리고 권장 `AGENTS.md` policy를 설치합니다. 그래서 Codex가 작업을 계획하고, repo-local context를 남기고, 위험한 변경을 gate로 확인하고, 다음 세션에도 쓸 수 있는 artifact를 남길 수 있게 합니다.

아주 작은 일회성 수정만 필요하다면 이 kit은 다소 과합니다. 하지만 여러 단계의 작업, code review, browser QA, 여러 세션에 걸친 작업이 많다면 도움이 됩니다.

## 30초 설명

- 이게 뭔가:
  Codex용 workflow kit입니다. 앱, daemon, framework, IDE plugin은 아닙니다.
- 무엇을 설치하나:
  `~/.codex/skills/` 아래의 skills, `~/.codex/templates/factory/` 아래의 templates, 그리고 `~/.codex/AGENTS.factory-kit.md`에 놓이는 권장 policy입니다.
- 어떤 문제를 푸나:
  Codex 세션은 task context를 잃거나, planning을 건너뛰거나, review와 QA 증거를 약하게 남기기 쉽습니다. 이 kit은 Codex가 repo-local working memory를 구조적으로 남기게 도와줍니다.
- 실제로 얻는 것:
  Codex가 repo의 `.codex/context/` 안에 `PLAN.md`, `TESTPLAN.md`, `REVIEW.jsonl`, `RELEASE.md`, `RETRO.md`, `LEARNINGS.jsonl`을 쓰거나 갱신할 수 있게 됩니다.

## 내부 파일을 먼저 배울 필요는 없습니다

`.codex/context/`, 숨김 폴더, `AGENTS.md`, `gitignore`를 먼저 이해하지 않아도 시작할 수 있습니다.

처음 쓰는 경로는 이렇게 생각하면 됩니다.

1. kit 설치
2. 필요하면 권장 policy 활성화
3. repo에서 bootstrap 명령 한 번 실행
4. Codex에게 "코딩 전에 먼저 계획하라"고 말하기

## 언제 쓰면 좋은가

다음 상황이라면 유용합니다.

- 장난감 prompt가 아니라 실제 repo에서 Codex를 쓴다
- 구현 전에 권장 route를 받고 싶다
- planning, review, QA, documentation이 매 세션마다 초기화되지 않고 누적되길 원한다
- 위험한 작업에 더 명확한 gate와 더 좁은 boundary를 원한다
- 작업이 여러 세션에 걸쳐 이어질 가능성이 높다

반대로 다음 상황이면 굳이 필요 없을 수 있습니다.

- 모든 작업이 아주 작은 1파일 수정이다
- repo에 지속적인 workflow artifact를 남기고 싶지 않다
- Codex가 그냥 빠르게 patch 하나만 만들고 끝나면 된다

## 실제로 무엇이 달라지나

이 kit이 없으면 많은 Codex 작업이 암묵적으로 남습니다.

- task scope가 무엇이었는지
- 무엇을 검증했는지
- review에서 무엇을 찾았는지
- 다음에 무엇을 기억해야 하는지

이 kit이 있으면 그 내용을 repo-local artifact로 명시할 수 있습니다.

- ask가 모호할 때 더 선명한 brief를 위한 `PRODUCT.md`
- 실행 계획을 위한 `PLAN.md`
- 검증 범위와 증거를 위한 `TESTPLAN.md`
- review findings와 gate status를 위한 `REVIEW.jsonl`
- 동작이나 setup 변경 기록을 위한 `RELEASE.md`
- 작업을 늦춘 원인을 남기는 `RETRO.md`
- 다음 작업에도 재사용할 guidance를 위한 `LEARNINGS.jsonl`
- 위험한 변경 범위를 좁게 잠글 때 쓰는 `FREEZE.md`

## 설치 경로는 둘 중 하나만 고르세요

이 repo를 로컬에 clone한 뒤, 아래 둘 중 하나를 선택합니다.

- 안전 설치만:

```bash
./install.sh
```

- 설치 후 권장 policy까지 바로 활성화:

```bash
./install.sh --adopt-policy
```

두 명령 모두 다음을 설치합니다.

- `skills/*` -> `~/.codex/skills/`
- `templates/factory/*` -> `~/.codex/templates/factory/`
- `AGENTS.md` -> `~/.codex/AGENTS.factory-kit.md`
- `VERSION`, `CHANGELOG.md`, `init-repo.sh` -> `~/.codex/factory-kit/`

안전 경로는 기존 `~/.codex/AGENTS.md`를 덮어쓰지 않습니다.
활성화 경로는 권장 policy를 `~/.codex/AGENTS.md`에 대신 복사해 줍니다.

옵션 차이 한 줄 정리:

- `./install.sh`：kit만 설치하고 기존 `~/.codex/AGENTS.md`는 건드리지 않습니다.
- `./install.sh --adopt-policy`：설치 후 권장 policy를 `~/.codex/AGENTS.md`에 바로 적용해 기본 policy로 사용합니다.

나중에 설치 상태를 확인하고 싶다면:

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh status
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
```

## 3분 설정

1. kit을 설치합니다.

```bash
git clone https://github.com/kevintseng/codex-factory-kit.git
cd codex-factory-kit
./install.sh --adopt-policy
```

policy를 먼저 읽고 싶다면 `./install.sh`를 사용하세요.

2. 이 kit을 쓰고 싶은 repo로 이동한 뒤 다음을 실행합니다.

```bash
~/.codex/factory-kit/init-repo.sh
```

이 명령이 빠진 context 파일을 만들고 `.gitignore`도 대신 갱신해 줍니다.

현재 경로가 대상 repo가 아니라면 `~/.codex/factory-kit/init-repo.sh --repo /path/to/repo`를 사용하세요.

이 bootstrap 명령의 차이:

- `--repo` 미사용: 현재 위치한 디렉터리를 초기화합니다.
- `--repo /path/to/repo` 사용: 지정한 경로를 초기화합니다(다른 폴더에서 실행할 때 유용).

3. 그 repo에서 Codex를 열고 이렇게 시작합니다.

```text
Plan this task before coding. Keep the workflow lightweight unless risk justifies more.
```

4. 사용자 흐름이 바뀌는 작업이면 마지막에 한 마디 더 붙입니다.

```text
This changes a browser or runtime flow. Verify it before we call it done.
```

이 kit이 처음이라면 첫날은 여기까지면 충분합니다. 일단 설치하고, repo를 초기화하고, Codex에게 먼저 plan하라고 말하면 됩니다. 아래의 고급 섹션은 작업이 더 크거나 더 위험해질 때 보면 됩니다.

## 최소 일상 사용법

작은 작업이라면:

1. Codex에게 코딩 전에 먼저 plan하라고 말합니다.
2. repo plan을 갱신하게 둡니다.
3. 변경을 구현합니다.
4. 위험이 커지지 않으면 나머지는 생략합니다.

더 크거나 더 위험한 작업이라면:

1. 아직 안 했다면 repo를 bootstrap합니다
2. 구현 전에 task를 classify하라고 Codex에게 말합니다
3. ask가 아직 모호하면 planning을 시킵니다
4. plan과 test plan을 쓰게 둡니다
5. 좁은 범위의 위험한 작업이면 scope를 잠급니다
6. 구현합니다
7. 필요하면 scope check를 합니다
8. structured review를 합니다
9. evidence가 중요하면 runtime 또는 browser 검증을 합니다
10. 동작이나 setup이 바뀌었으면 docs 또는 release notes를 갱신합니다
11. retro를 남깁니다
12. 재사용할 learning이 있으면 남깁니다

고급 이름 매핑:

- task 분류: `factory-router`
- plan 작성: `sprint-conductor`
- structured review: `review-gate`
- runtime 검증: `qa-runtime`

## 포함된 것

- Codex용 글로벌 skills:
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
- factory templates:
  - `PRODUCT.md`
  - `PLAN.md`
  - `TESTPLAN.md`
  - `REVIEW.jsonl.example`
  - `RELEASE.md`
  - `RETRO.md`
  - `LEARNINGS.jsonl.example`
  - `FREEZE.md`
- 권장 글로벌 `AGENTS.md` policy
- `~/.codex`로 skills와 templates를 복사하는 installer
- `docs/generated/` 아래의 generated contract references

## 왜 이런 workflow가 필요한가

핵심은 간단합니다. 매 턴마다 작업을 다시 설명하는 것보다 지속되는 artifact가 낫다는 점입니다.

Codex가 프로젝트 전체를 매번 단기 컨텍스트로만 기억하게 두지 말고, repo 안의 `.codex/context/`에 작업 artifact를 남기세요. 그러면 handoff, review, QA, 후속 작업이 훨씬 안정적입니다.

## workflow 모양

```text
모호한 task
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

## Repo별 도입

기본 경로:

```bash
~/.codex/factory-kit/init-repo.sh
```

이 명령은 기존 파일을 덮어쓰지 않고 빠진 repo-local artifact만 만듭니다.

고급 수동 fallback:

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

## 작업 흐름 예시

예를 들어 Codex에게 flaky한 checkout route를 고쳐 달라고 요청한다고 합시다.

workflow layer가 없으면:

- agent가 바로 code patch를 시작할 수 있습니다
- tests와 runtime verification이 암묵적으로 처리되거나 빠질 수 있습니다
- 다음 session에서 무엇이 바뀌었고 무엇이 아직 위험한지 다시 복원해야 합니다

Codex Factory Kit이 있으면:

1. `sprint-conductor`가 구체적인 `PLAN.md`를 씁니다
2. `review-gate`가 findings를 `REVIEW.jsonl`에 기록합니다
3. `qa-runtime`이 실제 검증 증거를 `TESTPLAN.md`에 남깁니다
4. `document-release`가 동작이 바뀌었으면 release notes를 갱신합니다
5. `retro`가 무엇이 작업을 늦췄는지 기록합니다
6. `learn`이 재사용할 교훈을 `LEARNINGS.jsonl`로 승격합니다
7. 다음 비슷한 작업에서는 `learn sync-context`가 관련 guidance를 다시 `PLAN.md`, `TESTPLAN.md`에 써 줍니다

더 구체적인 예시는 [docs/examples.md](docs/examples.md)를 보세요.
artifact가 어떻게 달라지는지 더 현실적인 전후 비교는 [docs/demo.md](docs/demo.md)를 보세요.

## Factory Router

`factory-router`는 공개 kit에 들어간 첫 번째 vNext capability입니다.

역할은 구현 전에 task를 분류하는 것입니다.

- lightweight mode인지 full mode인지
- `office-hours-codex`, `review-gate`, `qa-runtime`, `document-release`, `retro`가 필요한지
- 위험한 작업을 좁은 범위로 잠그기 위해 `freeze`, `guard`가 필요한지
- 작업을 로컬에 유지해야 하는지, 아니면 좁은 병렬 slice로 나눌 수 있는지
- 어떤 model class가 task를 이끌고 어떤 class가 bounded work를 안전하게 실행할 수 있는지

이것은 숨겨진 자동화가 아니라 soft orchestration입니다. router는 Codex가 맞는 workflow와 quality bar를 고르게 돕지만, 플랫폼이 위험한 작업을 몰래 가로채 실행한다고 주장하지는 않습니다.

## Freeze And Guard

이 kit에는 기본적인 safety layer도 포함됩니다.

- `freeze`는 allowed paths, blocked paths, protected invariants를 담은 `.codex/context/FREEZE.md`를 만듭니다
- `guard`는 최종 gate 전에 현재 diff가 그 freeze contract를 지켰는지 확인합니다

이 기능은 큰 repo에서 "위험하지만 범위는 좁아야 하는" 작업을 위한 것입니다. 모든 작은 수정마다 필요한 것은 아닙니다. 목표는 blast radius 제어를 명시적이고 확인 가능하게 만드는 것입니다.

## Governance Role Packs

이 kit에는 `review-gate` 위에 얹는 얇은 governance overlay도 포함됩니다.

- `founder-review`
- `eng-review`
- `design-review`
- `security-review`
- `release-review`

이것들은 대체 workflow가 아닙니다. 서로 다른 종류의 ship 결정에 대해 추가 review lens를 제공하는 선택적 overlay입니다.

## Learning Layer

이 kit에는 첫 번째 learning layer도 들어 있습니다.

- `learn`은 재사용 가능한 guidance를 `.codex/context/LEARNINGS.jsonl`에 승격합니다
- learning store는 repo-local이며 여러 task에 걸쳐 유지됩니다
- learning은 목록 조회, 새 task에 대한 추천, plan artifact로의 sync, stale해졌을 때 deactivate가 가능합니다

이것은 freeform memory dump가 아닙니다. 앞으로의 routing, review, QA, release, safety 동작을 바꿔야 할 guidance에만 쓰는 층입니다.

새 task가 과거 guidance와 맞으면 다음처럼 사용할 수 있습니다.

```bash
python3 ~/.codex/skills/learn/scripts/factory-kit-learn.py sync-context \
  --task-class ui_workflow \
  --tag browser
```

그러면 `.codex/context/PLAN.md`와 `.codex/context/TESTPLAN.md`의 `Relevant Learnings` 섹션이 갱신됩니다.

## Versioning, Release Checks, And Upgrade

이 kit에는 로컬 upgrade foundation과 첫 release-check layer도 포함됩니다.

- 최상위 `VERSION`
- 최상위 `CHANGELOG.md`
- `~/.codex/factory-kit/` 아래의 설치 metadata
- status, release check, repo checkout 기준 local refresh를 담당하는 `factory-kit-upgrade`

현재 할 수 있는 것:

- repo version과 installed version 보고
- 로컬 version을 최신 published GitHub release와 비교
- update-check 상태를 `~/.codex/factory-kit/update-state.json`에 저장
- 선택된 `CODEX_HOME` 감지
- 가능하면 install metadata에 저장된 source checkout path 재사용
- 현재 repo checkout 기준으로 설치된 factory-kit-owned skill pack과 templates refresh
- 은퇴한 factory-kit-owned skills와 templates는 정리하고, 관련 없는 사용자 파일은 그대로 둠

아직 하지 않는 것:

- 명시적 명령 없이 auto-upgrade
- update check를 먼저 알려 주거나 snooze
- repo-local `.codex/context/` artifact 재작성
- `~/.codex/AGENTS.md` 덮어쓰기

설치를 바꾸지 않고 최신 published release만 확인하고 싶다면 `check-updates`를 사용하세요.

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
```

현재 repo checkout이 installed version보다 오래되었다면, `upgrade`는 기본적으로 거부하고 `--allow-downgrade`를 요구합니다.

## Default Loop

작업이 여러 단계이거나, 리스크가 있거나, 여러 surface를 건드린다면 full loop를 사용하세요.

1. `bootstrap-context`
2. route가 아직 분명하지 않다면 `factory-router`
3. ask가 모호하면 `office-hours-codex`
4. blast radius를 좁게 유지해야 하면 `freeze`
5. `sprint-conductor`
6. repo-local agents로 구현
7. freeze contract가 있으면 `guard`
8. `review-gate`
9. `qa-runtime`
10. `document-release`
11. `retro`

## Lightweight Mode

다음이 모두 맞으면 lightweight mode를 쓰세요.

- 변경이 작고 경계가 분명하다
- browser나 여러 surface에 대한 검증이 명백히 필요하지 않다
- infra, migration, legal, security, fintech 리스크가 없다

lightweight mode에서는:

1. ask가 모호하지 않다면 `office-hours-codex`를 생략
2. `sprint-conductor`로 `PLAN.md`만 갱신
3. task가 커지지 않는 한 `TESTPLAN.md`, `RELEASE.md`, `RETRO.md`는 생략
4. 리스크가 커지지 않는 한 사소한 로컬 작업은 `review-gate` 생략

## Repo-Local Agents

이 repo는 여러분의 repo-specific specialist pack까지 제공하지는 않습니다.

의도한 모델은 다음과 같습니다.

- 재사용되는 workflow skills는 글로벌 `~/.codex/skills/`에 둔다
- 프로젝트 전용 agent는 `<repo>/.codex/agents/`에 둔다
- working memory는 `<repo>/.codex/context/`에 둔다

이렇게 분리하면 private project context를 드러내지 않고도 재사용 가능한 operating model만 공개할 수 있습니다.

## Public-Friendly By Design

이 repo는 의도적으로 다음을 제외합니다.

- private project prompt
- repo-local domain agent pack
- 개인 로그, 세션, auth, Codex state
- 여러분의 private repo에 있는 app-specific code

이 저장소는 재사용 가능한 layer만 담습니다.

## Publishing Model

이 repo는 private repo-local agent pack이나 개인 project context를 포함하지 않습니다. 재사용 가능한 layer만 포함합니다.

## Layout

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

## Docs

- [Adoption notes](docs/adoption.md)
- [Concrete demo](docs/demo.md)
- [Usage examples](docs/examples.md)
- [Share copy](docs/share.md)

## License

MIT
