# Codex Factory Kit

Codex Factory Kit은 흩어진 프롬프트 묶음이 아니라, 지속 가능한 작업 흐름으로 Codex를 쓰고 싶은 사람을 위한 워크플로 레이어입니다.

Languages: [English](README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md)

Codex를 일회성 지시 실행기가 아니라 단계형 실행 모델로 바꿔 주고, 구현 전에 경로를 고를 수 있는 `factory-router`, 위험한 편집의 blast radius를 줄이는 safety layer, 그리고 재사용 가능한 운영 지식을 남기는 learning layer도 제공합니다.

큰 작업은 보통 다음 흐름을 따릅니다.

1. bootstrap context
2. 작업 라우팅
3. 문제 명확화
4. 실행 계획 수립
5. 필요할 때 scope를 freeze
6. repo-local agents로 구현
7. frozen boundary에 대해 diff를 guard
8. 구조화된 review로 게이트
9. 런타임 검증
10. release notes 및 문서 갱신
11. retro 작성
12. 재사용할 learnings 승격

작은 작업을 위해서는 전체 프로세스를 매번 돌리지 않아도 되는 lightweight mode도 포함되어 있습니다.

## 누구에게 적합한가

다음에 해당하면 이 구성이 잘 맞습니다.

- Codex를 실제 repo에서 사용한다
- planning, review, QA, documentation이 세션마다 초기화되지 않고 누적되길 원한다
- `.codex/context/`에 repo-local working memory를 두고 싶다
- 작은 작업은 빠르게, 큰 작업은 더 안정적으로 처리하고 싶다

반대로 대부분의 작업이 아주 작은 1파일 수정이고, 지속적인 workflow artifact가 필요 없다면 다소 무거울 수 있습니다.

## 핵심 아이디어

대부분의 AI coding 환경은 매 턴마다 전체 작업 맥락을 다시 만들어야 한다는 같은 문제를 겪습니다.

Codex Factory Kit은 각 repo에 지속 가능한 artifact를 두어 그 문제를 줄입니다.

- `PRODUCT.md`
- `PLAN.md`
- `TESTPLAN.md`
- `REVIEW.jsonl`
- `RELEASE.md`
- `RETRO.md`
- `LEARNINGS.jsonl`
- 위험한 변경의 범위를 잠글 때 `FREEZE.md`

이렇게 하면 다음을 얻을 수 있습니다.

- 다중 세션 연속성 향상
- 메인 에이전트와 서브에이전트 간의 더 깔끔한 핸드오프
- 명시적인 review 및 QA 증거
- 반복 설명 감소

## 워크플로 모양

```text
모호한 요청
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

## 포함된 내용

- Codex용 글로벌 skills:
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
- 권장 글로벌 `AGENTS.md` policy
- skills와 templates를 `~/.codex`로 복사하는 설치 스크립트

## 왜 필요한가

핵심은 단순합니다. 작업을 매번 다시 설명하는 것보다 지속되는 artifact가 훨씬 낫다는 점입니다.

Codex가 프로젝트 전체를 매번 단기 컨텍스트만으로 기억하게 하지 말고, repo 안의 `.codex/context/`에 작업 artifact를 두세요.

- `PRODUCT.md`
- `PLAN.md`
- `TESTPLAN.md`
- `REVIEW.jsonl`
- `RELEASE.md`
- `RETRO.md`
- `LEARNINGS.jsonl`

이렇게 하면 핸드오프, review, QA, 후속 작업이 훨씬 안정적입니다.

## 설치

repo를 clone 한 뒤 다음을 실행하세요.

```bash
./install.sh
```

다음이 설치됩니다.

- `skills/*` -> `~/.codex/skills/`
- `templates/factory/*` -> `~/.codex/templates/factory/`
- `AGENTS.md` -> `~/.codex/AGENTS.factory-kit.md`
- `VERSION`과 `CHANGELOG.md` -> `~/.codex/factory-kit/`

설치 스크립트는 기존 `~/.codex/AGENTS.md`를 덮어쓰지 않습니다.

이 workflow를 기본 동작으로 쓰고 싶을 때만 수동으로 적용하세요.

```bash
cp ~/.codex/AGENTS.factory-kit.md ~/.codex/AGENTS.md
```

## Quick Start

1. 키트를 설치합니다.

```bash
git clone https://github.com/kevintseng/codex-factory-kit.git
cd codex-factory-kit
./install.sh
```

2. 필요하다면 권장 글로벌 policy를 적용합니다.

```bash
cp ~/.codex/AGENTS.factory-kit.md ~/.codex/AGENTS.md
```

3. 원하는 repo에서 로컬 working memory를 초기화합니다.

```bash
mkdir -p .codex/context
cp ~/.codex/templates/factory/PLAN.md .codex/context/PLAN.md
printf '\n.codex/context/\n' >> .gitignore
```

4. 작은 작업에는 lightweight mode, 위험도가 높거나 여러 단계가 필요한 작업에는 full loop를 사용합니다.

non-trivial 작업이라면 먼저 `factory-router`로 다음을 판단하는 것을 권장합니다.

- lightweight mode인지 full mode인지
- 어떤 follow-up skill이 필요한지
- lead / worker에 어떤 model-fit을 써야 하는지
- blast radius를 줄이기 위해 `freeze` / `guard`가 필요한지 여부

설치된 버전을 확인하거나 현재 repo checkout 기준으로 `~/.codex`의 kit을 새로 고치려면 다음을 실행하면 됩니다.

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh status
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh upgrade
```

## Repo별 도입

repo 내부에서 초기화하는 예시:

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

기존 artifact를 덮어쓰지 않고 점진적으로 만들고 싶다면 `bootstrap-context` skill도 사용할 수 있습니다.

## 작업 흐름 예시

예: Codex에게 flaky한 checkout route를 수정해 달라고 요청하는 경우.

workflow layer가 없으면:

- agent가 바로 code patch를 시작할 수 있다
- tests와 runtime verification이 암묵적이거나 생략될 수 있다
- 다음 session에서 무엇이 바뀌었고 무엇이 아직 위험한지 다시 복원해야 한다

Codex Factory Kit을 사용하면:

1. `sprint-conductor`가 구체적인 `PLAN.md`를 작성한다
2. `review-gate`가 findings를 `REVIEW.jsonl`에 기록한다
3. `qa-runtime`이 실제 검증 증거를 `TESTPLAN.md`에 남긴다
4. `document-release`가 필요한 경우 release notes를 갱신한다
5. `retro`가 무엇이 작업을 늦췄는지 남긴다
6. `learn`이 재사용 가능한 교훈을 `LEARNINGS.jsonl`로 승격한다
7. 다음 유사 작업에서는 `learn sync-context`로 관련 guidance를 `PLAN.md`와 `TESTPLAN.md`에 다시 반영한다

더 구체적인 예시는 [docs/examples.md](docs/examples.md)를 참고하세요.

## Factory Router

`factory-router`는 공개 kit에 들어간 첫 번째 정식 vNext capability입니다.

구현 전에 다음을 먼저 판단합니다.

- lightweight mode인지 full mode인지
- `office-hours-codex`, `review-gate`, `qa-runtime`, `document-release`, `retro`가 필요한지
- 위험한 작업을 좁은 범위에 가두기 위해 `freeze` / `guard`가 필요한지
- 작업을 로컬 critical path에 남겨야 하는지, 아니면 bounded parallel slices로 나눌 수 있는지
- 어떤 model class가 라우팅, 통합, 게이트를 주도하고 어떤 class가 bounded work를 안전하게 실행할 수 있는지

이것은 hidden automation이 아니라 soft orchestration입니다. Codex가 맞는 workflow와 quality bar를 고르게 돕는 것이지, 위험한 작업을 플랫폼 수준에서 자동 실행한다고 주장하는 것은 아닙니다.

## Freeze And Guard

이제 kit에는 기본 safety layer도 포함됩니다.

- `freeze`는 allowed paths, blocked paths, protected invariants를 담은 `.codex/context/FREEZE.md`를 만듭니다
- `guard`는 최종 gate 전에 현재 diff가 그 freeze contract를 지켰는지 확인합니다

이 기능은 큰 repo에서 “위험하지만 범위는 작아야 하는” 작업을 위한 것이지, 모든 작은 수정에 필요한 것은 아닙니다.

## Learning Layer

이제 kit에는 첫 learning layer도 포함됩니다.

- `learn`는 재사용 가능한 guidance를 `.codex/context/LEARNINGS.jsonl`에 저장합니다
- learning store는 repo-local이며 작업 간에 계속 사용할 수 있습니다
- 새 작업에 관련된 learnings를 추천하고 planning artifact에 반영할 수 있으며, 오래된 guidance는 비활성화할 수 있습니다

이것은 자유 형식 메모 덤프가 아닙니다. 이후의 routing, review, QA, release, safety 판단을 바꾸는 재사용 가능한 guidance를 위한 계층입니다.

새 작업이 기존 guidance와 맞을 때는 다음을 사용할 수 있습니다.

```bash
python3 ~/.codex/skills/learn/scripts/factory-kit-learn.py sync-context \
  --task-class ui_workflow \
  --tag browser
```

이 명령은 `.codex/context/PLAN.md`와 `.codex/context/TESTPLAN.md`의 `Relevant Learnings` 섹션을 갱신합니다.

## Versioning, Release Check, And Upgrade

이제 kit에는 로컬 업그레이드 기반과 첫 release-check layer도 포함됩니다.

- repo 루트의 `VERSION`
- repo 루트의 `CHANGELOG.md`
- `~/.codex/factory-kit/`에 설치되는 metadata
- `factory-kit-upgrade` skill과 스크립트

현재 가능한 것:

- repo 버전과 설치된 버전 보고
- 로컬 버전과 최신 공개 GitHub release 비교
- `~/.codex/factory-kit/update-state.json`에 update-check state 저장
- 대상 `CODEX_HOME` 감지
- 가능할 때 install metadata에 저장된 source checkout 경로 재사용
- 현재 repo checkout에서 설치된 skill pack과 templates 새로 고침

현재 하지 않는 것:

- 명시적 명령 없는 자동 업그레이드
- proactive update prompt나 snooze
- repo-local `.codex/context/` artifact 재작성
- `~/.codex/AGENTS.md` 덮어쓰기

설치를 바꾸지 않고 최신 공개 버전만 확인하려면 다음을 실행하면 됩니다.

```bash
./skills/factory-kit-upgrade/scripts/factory-kit-upgrade.sh check-updates
```

현재 repo checkout이 설치된 버전보다 오래된 경우 `upgrade`는 기본적으로 덮어쓰기를 거부하며, 실행하려면 명시적으로 `--allow-downgrade`를 줘야 합니다.

## 기본 루프

작업이 여러 단계이거나, 위험도가 높거나, 여러 surface에 걸쳐 있다면 full loop를 사용합니다.

1. `bootstrap-context`
2. 경로가 명확하지 않다면 `factory-router`
3. 요구가 모호하면 `office-hours-codex`
4. blast radius를 좁혀야 하면 `freeze`
5. `sprint-conductor`
6. repo-local agents로 구현
7. freeze contract가 있으면 `guard`
8. `review-gate`
9. `qa-runtime`
10. `document-release`
11. `retro`

## Lightweight Mode

다음이 모두 참이면 lightweight mode를 사용합니다.

- 변경이 작고 범위가 명확하다
- 브라우저 또는 multi-surface verification이 명확히 필요하지 않다
- infra, migration, legal, security, fintech 리스크가 없다

lightweight mode에서는:

1. 요청이 여전히 모호하지 않다면 `office-hours-codex`를 생략한다
2. `sprint-conductor`로 `PLAN.md`만 갱신한다
3. 작업이 커지지 않는 한 `TESTPLAN.md`, `RELEASE.md`, `RETRO.md`를 생략한다
4. 아주 작은 로컬 변경은 리스크가 커지지 않는 한 `review-gate`를 생략한다

## Repo-Local Agents

이 repo에는 각 프로젝트의 specialist pack이 포함되지 않습니다.

의도한 분리는 다음과 같습니다.

- 공통 workflow skills는 `~/.codex/skills/`
- project-specific agents는 `<repo>/.codex/agents/`
- working memory는 `<repo>/.codex/context/`

이렇게 분리하면 개인 프로젝트 맥락을 노출하지 않고 재사용 가능한 operating model만 공개할 수 있습니다.

## 공개 배포를 고려한 구성

이 repo는 의도적으로 다음을 포함하지 않습니다.

- private project prompts
- repo-local domain agent packs
- personal logs, sessions, auth, Codex state
- private repo의 app-specific code

포함된 것은 재사용 가능한 workflow layer뿐입니다.

## 디렉터리 구조

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

## 문서

- [Adoption notes](docs/adoption.md)
- [Usage examples](docs/examples.md)
- [Share copy](docs/share.md)

## License

MIT
