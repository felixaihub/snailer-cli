# Snailer 기여자용 아키텍처 안내 (한글)

본 문서는 `docs/CONTRIBUTOR_ARCHITECTURE.md` (영문)와 짝을 이루며, 공개 저장소 기여자가 현재 Snailer 구조를 빠르게 파악하고 엔진/도구/문서 등을 수정할 때 참고할 수 있도록 정리한 한글 요약입니다. 자세한 다이어그램이나 전체 흐름은 원문 문서와 `docs/ARCHITECTURE.md`, `docs/README_SNAILER.md` 등을 참고하세요.

## 핵심 요약

- **스택:** Rust 기반 CLI/라이브러리 (Cargo), helper 스크립트와 테스트는 `scripts/`, `tests/`, `swe_bench_*` 등.
- **진입점:** `src/main.rs` (CLI/REPL/MDAP/Signal 처리) + `src/daemon.rs` (JSON-RPC 서버).
- **운영 모드:** 단일 프롬프트 실행, 대화형 REPL, MDAP/GRPO/자동화 플래그, 지속형 히스토리·KB.
- **기여 대상:** `src/agent`, `src/tools.*`, `context/`, `skills/`, `build_*`, `docs/*`, `history.rs`, `analytics/` 등.
- **참조 문서:** `docs/ARCHITECTURE.md`, `docs/QUICKSTART.md`, `docs/SKILLS_*` 등.

## 저장소 구조

```
snailer/
├── src/
│   ├── main.rs, lib.rs                 # CLI/Daemon 진입, 모듈 재수출
│   ├── agent/                          # 계획/MDAP/컨텍스트/도구 조율
│   ├── tools.rs + tools/               # 툴 레지스트리, 승인 UI, run_cmd 계약
│   ├── api.rs, config.rs, ai_key_service.rs, crypto.rs  # 모델/키/LLM API
│   ├── context/*, ace/*, reasoning/*, reflection/*, curation/*  # ACE 메모리 파이프라인
│   ├── history.rs, diff.rs             # 히스토리/패치/undo
│   ├── build_pipeline.rs, build_orchestrator.rs, sarif.rs, repair_guard.rs  # 검증
│   ├── bash_session.rs                 # 명령 실행 & 보안
│   ├── analytics/, budget_manager.rs, pricing_table.rs  # 비용/계획/통계
│   ├── db.rs                           # Supabase 세션/작업 기록
│   ├── importers/, codewiki.rs         # 웹 캡처/CodeWiki
│   ├── skills/, user_skills/           # KB/스킬 인제스트
│   └── auth.rs, routing/, ui.rs         # 기타 헬퍼
├── docs/                                # 공개 문서(아키텍처, 사용자 가이드 등)
├── scripts/, tests/, swebench_*, proto/ # 빌드/테스트/자동화 자산
```

## 주요 모듈 & 기여 포인트

| 영역 | 역할 | 참조 docs | 기여 아이디어 |
|------|------|-----------|---------------|
| `src/main.rs` | CLI/REPL, MDAP 토글, 시그널/히스토리 로직 | `docs/README_SNAILER.md`, `docs/ARCHITECTURE.md` | 슬래시 커맨드 추가, 프롬프트 전처리 개선, 로그/샘플링 강화 |
| `src/agent/` | 계획/도구/예산/MDAP/스마트 라우터 | `docs/ARCHITECTURE.md`, `docs/MULTIMODAL_KB_AGENT_EXAMPLE.md` | 플래닝 튜닝, 예외 처리/페일오버, MDAP 강화 |
| `src/tools.rs` + `src/tools/` | 파일/명령/승인 UI | `docs/COMMANDS.md` | 신규 도구 추가, 중복 검사 강화, 승인 흐름 개선 |
| `context` 등 | ACE 메모리 (Generator→Reflector→Curator) | `docs/CONTEXT_COMPRESSION_DESIGN.md` | 신규 반영/정제 정책, 문맥 저장 방식 개선 |
| `skills/`, `user_skills/` | KB/스킬 인제스트 & 실행 | `docs/SKILLS_*`, `docs/MULTIMODAL_KB_GUIDE.md` | 새로운 파일 유형, 비전 처리, 스킬 문서화 |
| Build/verify | `build_*`, `sarif.rs`, `repair_guard.rs` | `docs/BUILD_PIPELINE_IMPLEMENTATION.md` | 언어/프레임워크 추가, 진단 파싱 개선, 자동 검증 |
| API/키 | `api.rs`, `config.rs`, `ai_key_service.rs`, `crypto.rs` | `docs/API_SPECIFICATION.md` | 새 모델/도구, JSON 파싱 강화, 키 오류 메시지 개선 |
| Analytics/budget | `analytics/`, `budget_manager.rs`, `pricing_table.rs`, `db.rs` | `docs/PRICING.md` | 가격표 테스트, 예산 시뮬레이션, 메트릭 시각화 제작 |
| `daemon.rs` | 에디터 JSON-RPC | `docs/DEVICE_FLOW_EXPLAINED.md` | RPC 확장, 인증/이벤트 개선 |
| `docs/` | 가이드/아키텍처 | `docs/ARCHITECTURE.md` | 문서 업데이트, 다이어그램 추가 |

`lib.rs`는 `Agent`, `Config`, `Tool`, `Context`, `AcePipeline`과 같이 바이너리/데몬이 공유하는 타입을 재수출합니다.

## 실행 흐름

### 1. 단일 프롬프트 실행

```
프롬프트 → `main.rs` → `run_single_task`
        ↓
환경/키/히스토리 로드 → Agent 생성
        ↓
Planner → tool 선택 → `api.rs`/LLM 호출
        ↓
`tools.rs` + `bash_session.rs` 실행 → 이력 기록 → MDAP 리포터
```

기여 포인트: 새 도구, `ToolRegistry` 검증, API 복원성, history/CodeWiki 확장 등.

### 2. 대화형 REPL

```
`snailer` (프롬프트 없음)
        ↓
헤더/슬래시 명령 + 상태 출력 (`main.rs`)
        ↓
`persistent_agent` + ContextStore 재사용
        ↓
기존 도구 루프 + `ui.rs` raw 모드 보호
```

새 명령, 세션 지속 개선, UI 업데이트 등이 기여 대상입니다.

### 3. 데몬/에디터

```
클라이언트 → WebSocket → `daemon.rs`
        ↓
`initialize`, `run_agent` 호출 → Agent 이벤트 → JSON-RPC 전송
        ↓
`agent.event`, `tool.execute` 알림 → 에디터 UI
```

RPC 확장, 인증, rich event payload 개선이 기여 포인트입니다.

## 지원 시스템

- **컨텍스트 & KB:** `context::Context`, `ace::AcePipeline`, `reasoning`, `reflection`, `curation`, `skills/`.
- **빌드 검증:** `build_pipeline.rs`, `build_orchestrator.rs`, `sarif.rs`, `repair_guard.rs`.
- **API 키:** `ai_key_service.rs`, `crypto.rs`, `account_config.rs`.
- **분석/예산:** `analytics::pricing`, `budget_manager.rs`, `pricing_table.rs`, `budget_monitor`, `db.rs`.

## ASCII 다이어그램

```
CLI/Daemon → Agent → {API, Context, Tools}
Tool loop → history + metrics
Build verification → SARIF → RepairGuard
```

자세한 다이어그램은 `docs/ARCHITECTURE.md`를 참고하세요.

## 다음 단계

1. `docs/ARCHITECTURE.md`, `docs/README_SNAILER.md`, `docs/SKILLS_*` 먼저 읽기.
2. `cargo test`, `scripts/run_comprehensive_tests.sh`, `swe_bench_tests.sh` 등 실행.
3. `src/agent`, `src/tools.rs`, 관련 docs를 읽고 흐름 이해.
4. 학습 내용을 문서화(이 문서, `docs/ARCHITECTURE.md` 업데이트 등)하고 PR 제출.

새 도구 추가, KB/빌드 지원 확장, 문서 동기화 등이 공개 기여 핵심입니다. 질문이 있으면 maintainer에게 문의하세요.
