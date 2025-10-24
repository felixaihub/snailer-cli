# ACE (Agentic Context Engineering) System

> 🧠 **목적**: Snailer의 자기 학습 컨텍스트 관리 시스템인 ACE의 원리와 구조를 설명합니다.

## 📚 목차

1. [개요](#개요)
2. [핵심 개념](#핵심-개념)
3. [시스템 구조](#시스템-구조)
4. [데이터 구조](#데이터-구조)
5. [실행 흐름](#실행-흐름)
6. [기여 방법](#기여-방법)

---

## 개요

ACE (Agentic Context Engineering)는 **AI 에이전트가 경험을 통해 학습**하고 스스로 개선되도록 하는 컨텍스트 관리 시스템입니다.

### 핵심 아이디어

기존 AI 에이전트는 매번 같은 실수를 반복하지만, ACE는:
1. ✅ 실행 과정을 추적하고 분석
2. ✅ 성공/실패 경험에서 교훈 추출
3. ✅ 교훈을 구조화된 컨텍스트로 저장
4. ✅ 다음 실행 시 컨텍스트를 활용하여 더 나은 결정

이를 통해 **Agent가 사용할수록 똑똑해집니다.**

### 연구 기반

이 구현은 다음 논문을 기반으로 합니다:
- ["Agentic Context Engineering: Evolving Contexts for Self-Improving Language Models"](https://arxiv.org/abs/2510.04618)

---

## 핵심 개념

### 1. Bullet (지식 단위)

ACE의 핵심 데이터 구조로, **원자적 지식 단위**입니다:

```rust
pub struct Bullet {
    pub id: Uuid,                    // 고유 ID
    pub content: String,             // 지식 내용
    pub bullet_type: BulletType,     // 타입 (STRATEGY, ERROR, etc.)
    pub layer: Layer,                // 계층 (PROJECT, FILE, FUNCTION)
    pub utility: f64,                // 유용성 점수 (0.0~1.0)
    pub usage_count: i32,            // 사용 횟수
    pub last_used: Option<DateTime>, // 마지막 사용 시간
    pub confidence: f64,             // 신뢰도 (0.0~1.0)
    pub tags: Vec<String>,           // 태그
}
```

**예시**:
```
Bullet {
    content: "Rust에서 비동기 함수는 반드시 .await을 호출해야 실행됨",
    bullet_type: KNOWLEDGE,
    layer: PROJECT,
    utility: 0.85,
    usage_count: 12,
    confidence: 0.95
}
```

### 2. Bullet Types (지식 타입)

```rust
pub enum BulletType {
    STRATEGY,   // 전략: 문제 해결 접근 방식
    ERROR,      // 에러: 실수와 수정 방법
    KNOWLEDGE,  // 지식: 사실 정보
    HEURISTIC,  // 휴리스틱: 경험 기반 규칙
    TOOL,       // 도구: 도구 사용 패턴
}
```

**예시**:
- STRATEGY: "복잡한 리팩토링은 테스트 작성 후 진행"
- ERROR: "unwrap() 대신 ?를 사용하여 에러 처리"
- KNOWLEDGE: "Cargo.toml에서 dependencies 섹션에 의존성 추가"
- HEURISTIC: "파일 크기가 500줄 이상이면 모듈 분리 고려"
- TOOL: "ripgrep으로 대규모 코드베이스 검색이 더 빠름"

### 3. Layers (계층)

컨텍스트를 계층적으로 관리:

```rust
pub enum Layer {
    PROJECT,   // 프로젝트 전체 (아키텍처, 컨벤션)
    FILE,      // 파일 수준 (모듈 구조, 주요 함수)
    FUNCTION,  // 함수 수준 (상세 구현 로직)
}
```

**계층별 용도**:
```
PROJECT Layer
├─ "이 프로젝트는 Rust로 작성된 CLI 도구"
├─ "src/에 핵심 로직, tests/에 테스트 코드"
└─ "Cargo.toml로 의존성 관리"

FILE Layer
├─ src/agent.rs: "Agent 구조체와 실행 루프"
├─ src/tools.rs: "도구 레지스트리와 실행"
└─ src/api.rs: "AI API 클라이언트"

FUNCTION Layer
├─ agent.rs::execute_tool_loop(): "최대 50회 반복, ESC로 취소 가능"
└─ tools.rs::tool_read_file(): "경로 검증 후 파일 읽기"
```

---

## 시스템 구조

ACE는 4개의 핵심 컴포넌트로 구성됩니다:

### 1. Generator (생성기)

**역할**: 태스크를 실행하고 추론 과정을 기록

```rust
pub struct Generator {
    api_client: ApiClient,
    tool_registry: ToolRegistry,
}

impl Generator {
    pub async fn execute_with_trace(
        &self,
        query: &str,
        selected_bullets: Vec<Bullet>
    ) -> Result<ReasoningTrace>
}
```

**동작**:
1. 컨텍스트에서 관련 Bullet 선택 (유용성 점수 기반)
2. Bullet을 시스템 프롬프트에 포함하여 AI 실행
3. 실행 과정을 ReasoningTrace로 기록

**Bullet 선택 알고리즘**:
```rust
score = ALPHA * usage_frequency
      + BETA * recency
      + GAMMA * relevance

// 기본값: ALPHA=0.5, BETA=0.3, GAMMA=0.2
```

---

### 2. Reflector (반성기)

**역할**: 실행 trace를 분석하여 교훈 추출

```rust
pub struct Reflector {
    api_client: ApiClient,
}

impl Reflector {
    pub async fn extract_lessons(
        &self,
        trace: &ReasoningTrace
    ) -> Result<Vec<LessonDelta>>
}
```

**동작**:
1. ReasoningTrace를 AI에게 전달
2. "무엇을 배웠는가?" 질문
3. 구조화된 Lesson을 반환받음

**LessonDelta 예시**:
```rust
LessonDelta {
    operation: ADD,
    bullet: Bullet {
        content: "파일 수정 전 백업 생성하면 안전함",
        bullet_type: HEURISTIC,
        confidence: 0.8,
    }
}
```

---

### 3. Curator (큐레이터)

**역할**: 교훈을 컨텍스트에 통합하고 관리

```rust
pub struct Curator {
    context_store: ContextStore,
}

impl Curator {
    // 교훈을 컨텍스트에 통합
    pub async fn integrate_lessons(
        &mut self,
        lessons: Vec<LessonDelta>
    ) -> Result<()>

    // 유용성 점수 업데이트
    pub fn update_utility_scores(&mut self, trace: &ReasoningTrace)

    // 낮은 점수 Bullet 제거
    pub fn prune_low_utility(&mut self)
}
```

**통합 전략**:

1. **Merge (병합)** - 유사도 > THETA_1 (0.92)
   ```
   기존: "Rust는 메모리 안전성 보장"
   새것: "Rust의 소유권 시스템이 메모리 안전성 제공"
   → 병합: "Rust의 소유권 시스템이 메모리 안전성을 보장함"
   ```

2. **Link (연결)** - 유사도 > THETA_2 (0.75)
   ```
   기존: "async 함수는 Future 반환"
   새것: "Future는 .await으로 실행"
   → 연결: 두 Bullet을 관련 지식으로 태그
   ```

3. **Add (추가)** - 유사도 < THETA_2
   ```
   완전히 새로운 지식 → 새 Bullet 생성
   ```

**유용성 점수 계산**:
```rust
utility = LAMBDA_1 * (success_count / total_count)
        + LAMBDA_2 * recency_factor
        + LAMBDA_3 * confidence

// 기본값: LAMBDA_1=0.6, LAMBDA_2=0.3, LAMBDA_3=0.1
```

---

### 4. ACE Pipeline (파이프라인)

**역할**: 전체 ACE 사이클 조율

```rust
pub struct AcePipeline {
    generator: Generator,
    reflector: Reflector,
    curator: Curator,
    config: AceConfig,
}

impl AcePipeline {
    // 주기적 반성 (매 N회 실행마다)
    pub async fn reflect(&mut self) -> Result<()>

    // 주기적 정제 (매 M회 실행마다)
    pub async fn refine(&mut self) -> Result<()>
}
```

**실행 주기**:
```
매 10회 실행 → reflect()  (교훈 추출)
매 100회 실행 → refine()  (컨텍스트 정제)
```

---

## 데이터 구조

### ReasoningTrace (추론 기록)

실행 과정의 모든 단계를 기록:

```rust
pub struct ReasoningTrace {
    pub query: String,                    // 원래 요청
    pub selected_bullets: Vec<Bullet>,    // 사용된 컨텍스트
    pub steps: Vec<ReasoningStep>,        // 실행 단계들
    pub outcome: Outcome,                 // 성공/실패
    pub duration_ms: u64,                 // 소요 시간
}

pub struct ReasoningStep {
    pub step_num: usize,
    pub thought: String,           // AI의 생각
    pub action: Action,            // 수행한 행동
    pub observation: String,       // 결과 관찰
}

pub enum Action {
    ToolCall { name: String, args: Value },
    FinalAnswer { content: String },
}
```

**예시**:
```rust
ReasoningTrace {
    query: "Cargo.toml에 serde 추가해줘",
    selected_bullets: [
        Bullet { content: "Cargo.toml의 dependencies 섹션에 추가", ... }
    ],
    steps: [
        ReasoningStep {
            step_num: 1,
            thought: "먼저 Cargo.toml을 읽어야 함",
            action: ToolCall { name: "read_file", args: {"path": "Cargo.toml"} },
            observation: "[dependencies]\nclap = \"4.5\""
        },
        ReasoningStep {
            step_num: 2,
            thought: "[dependencies] 섹션에 serde 추가",
            action: ToolCall { name: "edit_file", ... },
            observation: "성공적으로 추가됨"
        }
    ],
    outcome: SUCCESS,
    duration_ms: 1250
}
```

### LessonDelta (교훈 변경)

컨텍스트 업데이트 작업:

```rust
pub enum LessonOperation {
    ADD,      // 새 Bullet 추가
    UPDATE,   // 기존 Bullet 업데이트
    DELETE,   // Bullet 삭제
    MERGE,    // 여러 Bullet 병합
}

pub struct LessonDelta {
    pub operation: LessonOperation,
    pub bullet: Bullet,
    pub related_ids: Vec<Uuid>,  // 관련 Bullet ID들
}
```

---

## 실행 흐름

### 전체 ACE 사이클

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Generator: 태스크 실행                                    │
│    ┌─────────────────────────────────────────────────────┐ │
│    │ a. Context Store에서 관련 Bullet 선택                │ │
│    │    - 유용성 점수 기반 랭킹                           │ │
│    │    - Top-K 선택 (기본: 20개)                        │ │
│    │                                                      │ │
│    │ b. Bullet을 시스템 프롬프트에 포함                   │ │
│    │    "다음 지식을 활용하세요:"                         │ │
│    │    - Bullet 1: ...                                  │ │
│    │    - Bullet 2: ...                                  │ │
│    │                                                      │ │
│    │ c. AI 실행 및 추론 과정 기록                         │ │
│    │    → ReasoningTrace 생성                            │ │
│    └─────────────────────────────────────────────────────┘ │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. Reflector: 교훈 추출 (매 10회)                           │
│    ┌─────────────────────────────────────────────────────┐ │
│    │ a. ReasoningTrace를 AI에게 전달                      │ │
│    │    "이 실행에서 배운 교훈은?"                        │ │
│    │                                                      │ │
│    │ b. AI가 구조화된 Lesson 반환                         │ │
│    │    - 성공 패턴 식별                                  │ │
│    │    - 실패 원인 분석                                  │ │
│    │    - 개선 방법 제안                                  │ │
│    │                                                      │ │
│    │ c. LessonDelta 생성                                 │ │
│    │    → Curator로 전달                                  │ │
│    └─────────────────────────────────────────────────────┘ │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. Curator: 컨텍스트 업데이트                               │
│    ┌─────────────────────────────────────────────────────┐ │
│    │ a. 유사도 계산 (기존 Bullet vs 새 Lesson)            │ │
│    │    - 임베딩 벡터 비교                                │ │
│    │    - 코사인 유사도                                   │ │
│    │                                                      │ │
│    │ b. 통합 전략 결정                                    │ │
│    │    if similarity > 0.92: MERGE                       │ │
│    │    elif similarity > 0.75: LINK                      │ │
│    │    else: ADD                                         │ │
│    │                                                      │ │
│    │ c. Context Store 업데이트                            │ │
│    │    - Bullet 추가/수정/삭제                           │ │
│    │    - 유용성 점수 업데이트                            │ │
│    └─────────────────────────────────────────────────────┘ │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. Refine: 컨텍스트 정제 (매 100회)                         │
│    ┌─────────────────────────────────────────────────────┐ │
│    │ a. 유용성 점수 재계산                                │ │
│    │    - 최근 사용 패턴 분석                             │ │
│    │    - 성공률 업데이트                                 │ │
│    │                                                      │ │
│    │ b. 낮은 점수 Bullet 제거                             │ │
│    │    - 하위 20% 제거                                   │ │
│    │    - 최소 100개 유지                                 │ │
│    │                                                      │ │
│    │ c. 중복 Bullet 병합                                  │ │
│    │    - 높은 유사도 Bullet 통합                         │ │
│    └─────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### 코드 예시

```rust
// ACE Pipeline 사용
let mut pipeline = AcePipeline::new(config);

// 태스크 실행
for i in 0..1000 {
    let query = get_user_query();

    // 1. Generator: 실행 + 추론 기록
    let trace = pipeline.generator.execute_with_trace(
        &query,
        pipeline.context_store.select_relevant_bullets(&query, 20)
    ).await?;

    // 2. Reflector: 주기적 반성 (매 10회)
    if i % 10 == 0 {
        let lessons = pipeline.reflector.extract_lessons(&trace).await?;

        // 3. Curator: 컨텍스트 업데이트
        pipeline.curator.integrate_lessons(lessons).await?;
    }

    // 4. Refine: 주기적 정제 (매 100회)
    if i % 100 == 0 {
        pipeline.curator.prune_low_utility();
    }
}
```

---

## Context Store (컨텍스트 저장소)

### 영구 저장

```rust
pub struct ContextStore {
    bullets: HashMap<Uuid, Bullet>,
    file_path: PathBuf,  // ~/.snailer/context.json
}

impl ContextStore {
    // 컨텍스트 로드
    pub fn load(path: &Path) -> Result<Self>

    // 컨텍스트 저장
    pub fn save(&self) -> Result<()>

    // 관련 Bullet 검색
    pub fn select_relevant_bullets(&self, query: &str, k: usize) -> Vec<Bullet>

    // Bullet 추가
    pub fn add_bullet(&mut self, bullet: Bullet)

    // Bullet 업데이트
    pub fn update_bullet(&mut self, id: Uuid, bullet: Bullet)

    // Bullet 삭제
    pub fn delete_bullet(&mut self, id: Uuid)
}
```

### 저장 형식 (JSON)

```json
{
  "bullets": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "content": "Rust에서 String::from()으로 문자열 생성",
      "bullet_type": "KNOWLEDGE",
      "layer": "FUNCTION",
      "utility": 0.87,
      "usage_count": 15,
      "last_used": "2025-10-23T10:30:00Z",
      "confidence": 0.92,
      "tags": ["rust", "string", "conversion"]
    }
  ],
  "metadata": {
    "version": "1.0",
    "last_refined": "2025-10-23T10:00:00Z",
    "total_executions": 250
  }
}
```

---

## 성능 최적화

### 1. Latency Budget (지연 예산)

ACE는 실행 속도에 영향을 최소화:

```rust
pub struct AceConfig {
    pub latency_budget_ms: u64,  // 기본: 1000ms
    pub max_bullets_per_query: usize,  // 기본: 20
}

// Bullet 선택 시 시간 제한
let start = Instant::now();
let bullets = select_relevant_bullets(query);
if start.elapsed().as_millis() > config.latency_budget_ms {
    // 타임아웃 시 캐시된 결과 사용
    bullets = cached_bullets;
}
```

### 2. 캐싱

자주 사용되는 Bullet은 메모리에 캐시:

```rust
lazy_static! {
    static ref BULLET_CACHE: Mutex<LruCache<String, Vec<Bullet>>>
        = Mutex::new(LruCache::new(100));
}
```

### 3. 비동기 Refinement

Refinement는 백그라운드에서 실행:

```rust
tokio::spawn(async move {
    pipeline.refine().await;
});
```

---

## 기여 방법

### 🎯 기여 가능 영역

1. **Bullet 선택 알고리즘 개선**
   - 더 나은 랭킹 공식
   - 임베딩 기반 유사도 계산

2. **Reflection 품질 향상**
   - 더 구조화된 교훈 추출
   - 다양한 BulletType 지원

3. **Curation 전략 최적화**
   - 더 지능적인 병합 알고리즘
   - 동적 threshold 조정

4. **성능 개선**
   - 더 빠른 유사도 계산
   - 효율적인 저장 형식

### 📝 테스트 작성

```rust
#[cfg(test)]
mod tests {
    #[test]
    fn test_bullet_selection() {
        let store = ContextStore::new();
        store.add_bullet(Bullet {
            content: "Test knowledge".to_string(),
            utility: 0.9,
            ...
        });

        let results = store.select_relevant_bullets("test query", 5);
        assert!(results.len() <= 5);
        assert!(results[0].utility >= results[1].utility);
    }
}
```

---

## 모범 사례

### ✅ 좋은 Bullet 작성

```rust
// ✅ Good: 구체적이고 실행 가능
Bullet {
    content: "파일 수정 시 edit_file 도구 사용, old_text와 new_text 정확히 매칭 필요",
    bullet_type: TOOL,
    layer: FUNCTION,
}

// ❌ Bad: 추상적이고 모호
Bullet {
    content: "파일을 잘 수정해야 함",
    bullet_type: STRATEGY,
    layer: PROJECT,
}
```

### ✅ 적절한 Layer 선택

```rust
// PROJECT Layer: 프로젝트 전반적 지식
"이 프로젝트는 Tokio로 비동기 처리"

// FILE Layer: 모듈 수준 지식
"agent.rs는 Agent 구조체와 실행 루프 정의"

// FUNCTION Layer: 함수 상세 로직
"execute_tool_loop()는 최대 50회 반복, ESC로 취소"
```

---

## 다음 단계

- [에이전트 아키텍처](./AGENT_ARCHITECTURE.md)
- [도구 시스템](./TOOL_SYSTEM.md)
- [기여 가이드](./CONTRIBUTING.md)

---

## 참고 자료

- [ACE 논문](https://arxiv.org/abs/2510.04618)
- [Private Repo ACE README](../../docs/ACE_README.md)

---

## 라이선스

MIT License
