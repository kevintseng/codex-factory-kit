# Codex Factory Kit

Codex Factory Kit은 Codex community를 위한 오픈소스 workflow kit입니다.

실제 repo에서 Codex를 쓰면서, 흩어진 프롬프트보다 더 분명한 운영 모델을 원하는 사람을 위한 도구입니다.

Languages: [English](README.md) | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md)

기존 Codex capabilities를 staged execution, repo-local working memory, structured review, runtime QA evidence, 그리고 작은 작업을 위한 lightweight mode로 더 의도적으로 쓰게 도와줍니다.

큰 작업은 보통 다음 흐름을 따릅니다.

1. bootstrap context
2. 문제 명확화
3. 실행 계획 수립
4. repo-local agents로 구현
5. 구조화된 review로 게이트
6. 런타임 검증
7. release notes 및 문서 갱신
8. retro 작성

작은 작업을 위해서는 전체 프로세스를 매번 돌리지 않아도 되는 lightweight mode도 포함되어 있습니다.

non-trivial 작업이라면 `factory-router`로 먼저 시작해서 그 작업이 lightweight mode에 머물러야 하는지, full loop로 들어가야 하는지를 먼저 판단할 수도 있습니다.

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

이렇게 하면 다음을 얻을 수 있습니다.

- 다중 세션 연속성 향상
- 메인 에이전트와 서브에이전트 간의 더 깔끔한 핸드오프
- 명시적인 review 및 QA 증거
- 반복 설명 감소

## 워크플로 모양

```text
모호한 요청
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

## Capability Router

첫 번째 vNext wedge는 `factory-router`로 shipped 됩니다.

깊은 작업에 들어가기 전에 rule-based routing decision이 필요할 때 사용합니다. 작업이 lightweight mode인지 full loop인지 판단하고, 다음에 `office-hours-codex`, `sprint-conductor`, `review-gate`, `qa-runtime`, `document-release`, `retro` 중 무엇이 필요한지도 제안합니다.

`factory-router`는 soft orchestration이며, platform-level 강제 실행을 주장하지 않습니다.

## 포함된 내용

- Codex용 글로벌 skills:
  - `factory-router`
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
- 권장 글로벌 `AGENTS.md` policy
- skills와 templates를 `~/.codex`로 복사하는 설치 스크립트

## 왜 필요한가

핵심은 단순합니다. 작업을 매번 다시 설명하는 것보다 지속되는 artifact가 훨씬 낫다는 점입니다.

이 프로젝트는 Codex platform primitives를 대체하려는 것이 아니라, 실제 작업에서 Codex를 더 잘 쓰기 위한 실용적인 커뮤니티 기여로 만들어졌습니다.

Codex가 프로젝트 전체를 매번 단기 컨텍스트만으로 기억하게 하지 말고, repo 안의 `.codex/context/`에 작업 artifact를 두세요.

- `PRODUCT.md`
- `PLAN.md`
- `TESTPLAN.md`
- `REVIEW.jsonl`
- `RELEASE.md`
- `RETRO.md`

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
5. 먼저 routing decision이 필요하면 `factory-router`를 사용합니다.

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

더 구체적인 예시는 [docs/examples.md](docs/examples.md)를 참고하세요.

## 기본 루프

작업이 여러 단계이거나, 위험도가 높거나, 여러 surface에 걸쳐 있다면 full loop를 사용합니다.

선택 가능한 첫 단계:
- `factory-router`

1. `bootstrap-context`
2. 요구가 모호하면 `office-hours-codex`
3. `sprint-conductor`
4. repo-local agents로 구현
5. `review-gate`
6. `qa-runtime`
7. `document-release`
8. `retro`

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

상위 수준의 repo 구조는 다음과 같습니다.

```text
.
├── AGENTS.md
├── install.sh
├── skills/
│   ├── factory-router/
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

각 skill 디렉터리에는 설치 후 Codex surface에서 쓰이는 `agents/openai.yaml` 인터페이스 매니페스트도 포함됩니다.

## 문서

- [Adoption notes](docs/adoption.md)
- [Concrete demo](docs/demo.md)
- [Usage examples](docs/examples.md)
- [Share copy](docs/share.md)

## License

MIT
