# Snailer Agent Architecture

> 🎯 **목적**: Snailer의 핵심 AI 에이전트 아키텍처를 이해하고 기여할 수 있도록 설계 원칙과 구조를 설명합니다.

## 📚 목차

1. [개요](#개요)
2. [핵심 컴포넌트](#핵심-컴포넌트)
3. [실행 모드](#실행-모드)
4. [도구 실행 루프](#도구-실행-루프)
5. [컨텍스트 관리](#컨텍스트-관리)
6. [기여 가이드](#기여-가이드)

---

## 개요

Snailer Agent는 **대화형 AI 기반 개발 에이전트**로, 사용자의 자연어 요청을 받아 파일 작업, 코드 분석, 검색 등의 도구를 자동으로 실행하여 작업을 수행합니다.

### 핵심 설계 원칙

1. **도구 중심 설계**: AI가 필요에 따라 도구를 선택하고 실행
2. **취소 가능성**: 사용자가 언제든 작업을 중단 가능 (ESC 키)
3. **컨텍스트 관리**: 대화 히스토리와 프로젝트 컨텍스트를 효율적으로 관리
4. **다중 모델 지원**: Claude, GPT, Grok, Gemini 등 여러 AI 모델 지원
5. **로컬 우선**: 로컬 데이터베이스에 메트릭 저장, 오프라인 작동 가능

---

## 핵심 컴포넌트

### 1. Agent 구조체

```rust
pub struct Agent {
    // 기본 설정
    prompt: String,                        // 사용자 요청
    project_path: PathBuf,                 // 작업 디렉토리
    model: String,                         // AI 모델 (claude-4.5, gpt-5, etc.)

    // 핵심 컴포넌트
    api_client: ApiClient,                 // AI API 클라이언트
    tool_registry: ToolRegistry,           // 도구 레지스트리
    conversation_history: Vec<Value>,      // 대화 히스토리

    // 제어 플래그
    cancel_flag: Arc<AtomicBool>,          // 취소 신호

    // 추적 시스템
    user_id: Option<String>,               // 사용자 ID
    db: Option<MetricsDb>,                 // 로컬 메트릭 DB
    session_id: Option<Uuid>,              // 세션 ID
    task_id: Option<Uuid>,                 // 태스크 ID

    // 메트릭
    tool_calls_count: i32,                 // 도구 호출 수
    tool_errors_count: i32,                // 에러 수
    last_iterations: i32,                  // 마지막 반복 횟수
}
```

### 2. ApiClient

여러 AI 모델과의 통신을 추상화:

```rust
impl ApiClient {
    // Claude (Anthropic)
    pub async fn send_message_to_claude() -> Result<Value>

    // OpenAI (GPT)
    pub async fn send_message_to_openai() -> Result<Value>

    // xAI (Grok)
    pub async fn send_message_to_grok() -> Result<Value>

    // Google (Gemini)
    pub async fn send_message_to_gemini() -> Result<Value>
}
```

**특징**:
- 통일된 인터페이스로 모델 전환 용이
- 토큰 사용량 자동 추적
- 에러 핸들링 및 재시도 로직

### 3. ToolRegistry

사용 가능한 모든 도구를 관리하고 실행:

```rust
pub struct ToolRegistry {
    project_path: PathBuf,
}

impl ToolRegistry {
    pub fn execute_tool(&self, tool_name: &str, params: Value) -> Result<String>
}
```

**지원 도구**:
- `shell`: 셸 명령 실행
- `read_file`: 파일 읽기
- `write_file`: 파일 쓰기
- `list_files`: 디렉토리 목록
- `search_files`: 파일 내용 검색
- `git_*`: Git 명령들

---

## 실행 모드

Snailer Agent는 3가지 실행 모드를 지원합니다:

### 1. Simple Mode (단순 모드)

```rust
pub async fn run_simple_mode(&mut self) -> Result<()>
```

**특징**:
- 도구 호출 없이 단순 질의응답만 수행
- 빠른 응답이 필요한 경우 사용
- 컨텍스트가 간단한 질문에 적합

**사용 사례**:
```bash
snailer --prompt "Rust에서 async/await의 원리 설명해줘"
```

### 2. Agent Mode (에이전트 모드)

```rust
pub async fn run_agent_mode(&mut self) -> Result<()>
```

**특징**:
- 도구 호출 루프를 통한 복잡한 작업 수행
- AI가 필요에 따라 도구를 선택하고 실행
- 최대 50회 반복 (무한 루프 방지)

**사용 사례**:
```bash
snailer --agent --prompt "모든 .rs 파일에서 TODO 주석 찾아서 정리해줘"
```

**실행 흐름**:
```
1. 시스템 프롬프트 생성
   ├─ 도구 정의 포함
   └─ 프로젝트 컨텍스트 포함

2. 사용자 프롬프트 추가

3. execute_tool_loop(max_iterations=50)
   └─ 도구 실행 루프 시작
```

### 3. GRPO Rollout Mode (실험 모드)

```rust
pub async fn run_grpo_rollout(&mut self, group_size: usize) -> Result<()>
```

**특징**:
- Training-Free GRPO (Group Relative Policy Optimization)
- 동일 작업을 여러 번 시도하여 최적 결과 선택
- 실험적 기능으로 연구 목적

**사용 사례**:
```bash
snailer --grpo --group-size 4 --prompt "복잡한 리팩토링 작업"
```

---

## 도구 실행 루프

Agent Mode의 핵심인 **도구 실행 루프**의 상세 동작:

### 실행 흐름

```
┌─────────────────────────────────────────────────────────────┐
│ 1. AI에게 메시지 전송                                        │
│    - 시스템 프롬프트 (도구 정의 포함)                        │
│    - 대화 히스토리                                           │
│    - 현재 사용자 요청                                        │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. AI 응답 파싱                                              │
│    ├─ Text Block: 사용자에게 표시                            │
│    └─ Tool Use Block: 도구 호출 요청                         │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. 도구 실행 (각 Tool Use Block마다)                        │
│    ├─ tool_registry.execute_tool()                          │
│    ├─ 결과 수집                                              │
│    └─ 에러 핸들링                                            │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. Tool Result 추가                                          │
│    - conversation_history에 도구 실행 결과 추가              │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│ 5. 종료 조건 확인                                            │
│    ├─ stop_reason == "end_turn" → 종료                      │
│    ├─ cancel_flag 설정 → 종료                               │
│    ├─ max_iterations 도달 → 종료                            │
│    └─ 아니면 1번으로 돌아가기                                │
└─────────────────────────────────────────────────────────────┘
```

### 코드 예시

```rust
pub async fn execute_tool_loop(
    &mut self,
    system_prompt: Value,
    max_iterations: usize
) -> Result<()> {
    for iteration in 0..max_iterations {
        // 1. AI 호출
        let response = self.api_client.send_message(
            &self.model,
            system_prompt.clone(),
            self.conversation_history.clone()
        ).await?;

        // 2. 응답 파싱
        let content_blocks = response["content"].as_array()?;

        for block in content_blocks {
            if block["type"] == "text" {
                // 텍스트 출력
                println!("{}", block["text"]);
            } else if block["type"] == "tool_use" {
                // 3. 도구 실행
                let tool_name = block["name"].as_str()?;
                let tool_input = block["input"].clone();

                let result = self.tool_registry.execute_tool(
                    tool_name,
                    tool_input
                )?;

                // 4. 결과 추가
                self.conversation_history.push(json!({
                    "role": "user",
                    "content": [{
                        "type": "tool_result",
                        "tool_use_id": block["id"],
                        "content": result
                    }]
                }));
            }
        }

        // 5. 종료 조건
        if response["stop_reason"] == "end_turn" {
            break;
        }

        if self.cancel_flag.load(Ordering::SeqCst) {
            println!("작업이 취소되었습니다.");
            break;
        }
    }

    Ok(())
}
```

---

## 컨텍스트 관리

### 1. 대화 히스토리

```rust
conversation_history: Vec<Value>
```

**구조**:
```json
[
  {
    "role": "user",
    "content": "파일 목록을 보여줘"
  },
  {
    "role": "assistant",
    "content": [
      {
        "type": "tool_use",
        "id": "toolu_123",
        "name": "list_files",
        "input": {"path": "."}
      }
    ]
  },
  {
    "role": "user",
    "content": [
      {
        "type": "tool_result",
        "tool_use_id": "toolu_123",
        "content": "file1.rs\nfile2.rs"
      }
    ]
  }
]
```

### 2. 컨텍스트 압축

토큰 제한을 초과할 때 오래된 대화를 압축:

```rust
pub async fn compact_context(&mut self) -> Result<()> {
    // 오래된 대화를 요약
    // 최근 N개 메시지는 유지
    // 나머지는 AI로 요약하여 단일 메시지로 압축
}
```

### 3. ACE (Agentic Context Engineering)

**ACE 시스템**은 컨텍스트를 계층적으로 관리:

- **Project Layer**: 프로젝트 전체 정보
- **File Layer**: 파일 수준 컨텍스트
- **Function Layer**: 함수/클래스 수준 상세 정보

자세한 내용은 `ACE_SYSTEM.md` 참조.

---

## VS (Verification/Selection) 블록

AI의 의사결정 과정을 투명하게 보여주는 시스템:
현재 비공개 상태입니다. -> private repo.

**활용**:
- AI의 추론 과정 추적
- 디버깅 및 품질 개선
- 사용자에게는 최종 결과만 표시

---

## 데이터베이스 추적

### 로컬 SQLite DB

```rust
pub struct MetricsDb {
    conn: Connection,  // SQLite 연결
}
```

**추적 항목**:

1. **세션 (Sessions)**
   - 세션 ID, 사용자 ID, 시작/종료 시간

2. **태스크 (Tasks)**
   - 태스크 ID, 프롬프트, 성공/실패, 반복 횟수

3. **모델 호출 (Model Calls)**
   - 입력/출력 토큰 수
   - 비용 계산
   - 레이턴시

4. **GRPO 데이터** (실험적)
   - Rollout 그룹
   - 각 시도별 보상 점수

### 사용 예시

```rust
// 세션 시작
agent.init_db_tracking("user-123").await?;

// 태스크 시작
agent.start_new_task_db().await?;

// 태스크 완료
agent.complete_current_task_db(success, iterations).await?;

// 세션 종료
agent.end_session_db().await?;
```

---

## 취소 메커니즘

사용자가 ESC 키로 언제든 작업 중단 가능:

### 구현

```rust
// Agent에 cancel_flag
cancel_flag: Arc<AtomicBool>

// 별도 스레드에서 ESC 키 모니터링
thread::spawn(move || {
    loop {
        if poll(Duration::from_millis(100))? {
            if let Event::Key(KeyEvent { code: KeyCode::Esc, .. }) = read()? {
                cancel_flag.store(true, Ordering::SeqCst);
                break;
            }
        }
    }
});

// 도구 루프에서 체크
if self.cancel_flag.load(Ordering::SeqCst) {
    println!("작업이 취소되었습니다.");
    return Ok(());
}
```
## 기여 가이드

### 🎯 기여 가능 영역

1. **새로운 도구 추가**
   - `ToolRegistry`에 새 도구 구현
   - 예: `database_query`, `api_call` 등

2. **새로운 AI 모델 지원**
   - `ApiClient`에 새 모델 추가
   - 예: Anthropic Claude Opus, GPT-5 등

3. **컨텍스트 관리 개선**
   - ACE 알고리즘 최적화
   - 압축 전략 개선

4. **성능 최적화**
   - 토큰 사용량 최소화
   - 도구 실행 속도 향상

5. **사용자 경험 개선**
   - 더 나은 에러 메시지
   - 진행 상황 표시
   - 자동완성 개선

### 📝 코드 스타일

```rust
// ✅ Good
pub async fn execute_tool(&self, name: &str) -> Result<String> {
    // 1. 입력 검증
    if name.is_empty() {
        return Err(anyhow!("Tool name cannot be empty"));
    }

    // 2. 도구 실행
    let result = match name {
        "shell" => self.execute_shell()?,
        _ => return Err(anyhow!("Unknown tool: {}", name)),
    };

    // 3. 결과 반환
    Ok(result)
}

// ❌ Bad - 에러 처리 없음
pub fn execute_tool(&self, name: &str) -> String {
    match name {
        "shell" => self.execute_shell(),
        _ => panic!("Unknown tool"),
    }
}
```

### 🧪 테스트 작성

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_agent_simple_mode() {
        let mut agent = Agent::new(
            "Hello".to_string(),
            PathBuf::from("."),
            "claude-4.5".to_string()
        ).unwrap();

        let result = agent.run_simple_mode().await;
        assert!(result.is_ok());
    }
}
```

### 📋 Pull Request 체크리스트

- [ ] 코드가 `cargo fmt`로 포맷되어 있음
- [ ] `cargo clippy`로 린트 통과
- [ ] 테스트 추가 및 통과
- [ ] 문서 업데이트 (필요시)
- [ ] 변경 사항을 CHANGELOG.md에 추가

---

## 다음 단계

- [도구 시스템 상세 가이드](./TOOL_SYSTEM.md)
- [ACE 컨텍스트 관리](./ACE_SYSTEM.md)
- [실행 모드 비교](./EXECUTION_MODES.md)
- [데이터베이스 스키마](./DATABASE_SCHEMA.md)

---

## 라이선스

MIT License - 자유롭게 사용, 수정, 배포 가능합니다.
