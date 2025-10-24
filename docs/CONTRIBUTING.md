# Snailer 기여 가이드

> 🎯 **목표**: 실리콘밸리 빅테크 수준의 코드 품질과 협업 문화를 유지하며, 모든 기여자가 성공적으로 기여할 수 있도록 돕습니다.

**환영합니다!** Snailer 프로젝트에 기여해주셔서 감사합니다. 이 가이드는 Google, Meta, Microsoft 등의 오픈소스 프로젝트 기여 프로세스를 참고하여 작성되었습니다.

---

## 📚 목차

1. [시작하기 전에](#시작하기-전에)
2. [개발 환경 설정](#개발-환경-설정)
3. [개발 워크플로우](#개발-워크플로우)
4. [코드 작성 가이드](#코드-작성-가이드)
5. [테스트 작성](#테스트-작성)
6. [Pull Request 프로세스](#pull-request-프로세스)
7. [코드 리뷰](#코드-리뷰)
8. [커뮤니티 가이드라인](#커뮤니티-가이드라인)

---

## 시작하기 전에

### 행동 강령 (Code of Conduct)

우리는 모든 기여자가 존중받고 환영받는 환경을 만들기 위해 노력합니다.

**✅ 권장 행동**:
- 다양한 관점과 경험을 존중하기
- 건설적인 피드백을 주고받기
- 커뮤니티의 이익을 우선 생각하기
- 실수를 인정하고 배우기
- 초보자를 돕고 멘토링하기

**❌ 금지 행동**:
- 차별적이거나 모욕적인 언어 사용
- 개인 공격이나 괴롭힘
- 타인의 개인 정보 무단 공개
- 전문적이지 않은 행동

위반 사례는 conduct@snailer.dev로 보고해 주세요. 모든 신고는 기밀로 처리됩니다.

### 기여 유형

| 유형 | 난이도 | 예시 | 시작 방법 |
|-----|--------|------|----------|
| 📝 **문서** | 🟢 초급 | 오타 수정, 예제 추가, 번역 | [Good First Issue](https://github.com/your-org/snailer/labels/good-first-issue) |
| 🐛 **버그 수정** | 🟡 중급 | 버그 재현 및 수정 | [Bug 라벨](https://github.com/your-org/snailer/labels/bug) |
| ✨ **기능 추가** | 🔴 고급 | 새 도구, 모델 지원 | [Feature Request](https://github.com/your-org/snailer/labels/feature) |
| 🧪 **테스트** | 🟢 초급 | 단위/통합 테스트 추가 | [Needs Tests](https://github.com/your-org/snailer/labels/needs-tests) |
| ⚡ **성능** | 🔴 고급 | 최적화, 프로파일링 | [Performance](https://github.com/your-org/snailer/labels/performance) |

### 기여하기 전 체크리스트

- [ ] 이슈가 이미 존재하는지 확인했나요?
- [ ] 중복된 PR이 없는지 확인했나요?
- [ ] 큰 변경사항은 먼저 이슈를 열어 논의했나요?
- [ ] 기여 가이드를 읽었나요?

---

## 개발 환경 설정

### 필수 도구

#### 1. Rust 툴체인 (최신 stable)

```bash
# rustup 설치
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 버전 확인
rustc --version  # 1.75.0 이상
cargo --version
```

#### 2. 필수 컴포넌트

```bash
# 코드 포맷터
rustup component add rustfmt

# 린터
rustup component add clippy

# (선택) 문서 생성
rustup component add rust-docs
```

#### 3. 추천 도구

```bash
# 빠른 빌드를 위한 캐시
cargo install sccache
export RUSTC_WRAPPER=sccache

# 파일 변경 감지 및 자동 재빌드
cargo install cargo-watch

# 의존성 관리
cargo install cargo-edit

# 테스트 커버리지
cargo install cargo-tarpaulin
```

#### 4. 코드 에디터 설정

**VS Code (권장)**:
```json
// .vscode/settings.json
{
  "rust-analyzer.checkOnSave.command": "clippy",
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "rust-lang.rust-analyzer",
  "[rust]": {
    "editor.tabSize": 4,
    "editor.insertSpaces": true
  }
}
```

**필수 확장**:
- `rust-lang.rust-analyzer` (공식 Rust 언어 서버)
- `vadimcn.vscode-lldb` (디버깅)
- `serayuzgur.crates` (의존성 버전 확인)

### 저장소 설정

#### 1. Fork & Clone

```bash
# 1. GitHub에서 Fork 버튼 클릭
# 2. 본인의 fork를 clone
git clone https://github.com/YOUR_USERNAME/snailer.git
cd snailer

# 3. Upstream 리모트 추가
git remote add upstream https://github.com/your-org/snailer.git

# 4. 리모트 확인
git remote -v
# origin    https://github.com/YOUR_USERNAME/snailer.git (fetch)
# origin    https://github.com/YOUR_USERNAME/snailer.git (push)
# upstream  https://github.com/your-org/snailer.git (fetch)
# upstream  https://github.com/your-org/snailer.git (push)
```

#### 2. 빌드 및 테스트

```bash
# 전체 빌드 (첫 빌드는 시간이 걸릴 수 있음)
cargo build

# 릴리스 빌드
cargo build --release

# 테스트 실행
cargo test

# 특정 테스트만 실행
cargo test test_agent

# 린트 검사
cargo clippy -- -D warnings

# 코드 포맷 확인
cargo fmt -- --check
```

#### 3. 환경 변수 설정

```bash
# .env 파일 생성 (템플릿 복사)
cp .env.example .env

# 필요한 API 키 설정
cat > .env << EOF
ANTHROPIC_API_KEY=sk-ant-your-key-here
OPENAI_API_KEY=sk-your-key-here
RUST_LOG=debug
EOF
```

---

## 개발 워크플로우

### 브랜치 전략

우리는 **GitHub Flow**를 사용합니다 (단순하고 명확한 워크플로우).

#### 브랜치 명명 규칙

```
<타입>/<이슈번호>-<간단한-설명>
```

**타입**:
- `feat/` - 새로운 기능
- `fix/` - 버그 수정
- `docs/` - 문서 변경
- `test/` - 테스트 추가/수정
- `refactor/` - 리팩토링
- `perf/` - 성능 개선
- `chore/` - 빌드, 설정 등

**예시**:
```bash
git checkout -b feat/123-add-http-tool
git checkout -b fix/456-agent-memory-leak
git checkout -b docs/789-update-readme
```

### 일반적인 개발 사이클

#### 1️⃣ 이슈 생성 또는 선택

```bash
# Good First Issue 찾기
# https://github.com/your-org/snailer/labels/good-first-issue

# 이슈에 코멘트로 작업 의사 표현
# "I'd like to work on this issue. Could you assign it to me?"
```

#### 2️⃣ 브랜치 생성 및 작업

```bash
# upstream에서 최신 코드 가져오기
git checkout main
git pull upstream main

# 새 브랜치 생성
git checkout -b feat/123-add-http-tool

# 작업 진행...
# (코드 작성, 테스트 추가)

# 자주 커밋하기 (작은 단위로)
git add src/tools/http.rs
git commit -m "feat: add basic HTTP client tool structure"

git add tests/tools/http_test.rs
git commit -m "test: add unit tests for HTTP tool"
```

#### 3️⃣ 코드 품질 확인

```bash
# 자동으로 전체 체크 실행
make check  # 또는 아래 명령들 개별 실행

# 1. 포맷 확인 및 수정
cargo fmt

# 2. Clippy 린트 (경고를 에러로 처리)
cargo clippy -- -D warnings

# 3. 테스트 실행
cargo test

# 4. 문서 빌드 확인
cargo doc --no-deps

# 5. (선택) 벤치마크 실행
cargo bench
```

#### 4️⃣ 커밋 메시지 작성

**Conventional Commits** 스타일을 따릅니다:

```
<타입>(<스코프>): <제목>

<본문>

<푸터>
```

**타입**:
- `feat`: 새로운 기능
- `fix`: 버그 수정
- `docs`: 문서 변경
- `style`: 코드 포맷 (동작 변경 없음)
- `refactor`: 리팩토링
- `perf`: 성능 개선
- `test`: 테스트 추가/수정
- `chore`: 빌드, 패키지 매니저 설정 등

**예시**:

```
feat(tools): add HTTP request tool with retry logic

Implement a new HTTP tool that supports:
- GET/POST/PUT/DELETE methods
- Automatic retry with exponential backoff
- Timeout configuration
- Custom headers support

Closes #123
```

**좋은 커밋 메시지**:
```
✅ feat(agent): implement context compression for long conversations
✅ fix(db): resolve SQLite connection pool exhaustion
✅ docs(readme): add installation instructions for Windows
✅ test(tools): add integration tests for shell command tool
```

**나쁜 커밋 메시지**:
```
❌ fix bug
❌ update code
❌ WIP
❌ asdfasdf
```

#### 5️⃣ Push 및 PR 생성

```bash
# 본인의 fork에 push
git push origin feat/123-add-http-tool

# GitHub에서 Pull Request 생성
# (자동으로 PR 생성 링크가 나타남)
```

---

## 코드 작성 가이드

### Rust 코딩 스타일

#### 1. 네이밍 컨벤션

```rust
// ✅ 구조체: PascalCase
pub struct ToolRegistry {
    // ✅ 필드: snake_case
    project_path: PathBuf,
    tool_cache: HashMap<String, Box<dyn Tool>>,
}

// ✅ 함수/메서드: snake_case
pub async fn execute_tool(&self, name: &str) -> Result<String> {
    // ✅ 로컬 변수: snake_case
    let tool_result = self.run_internal(name).await?;

    // ✅ 상수: SCREAMING_SNAKE_CASE
    const MAX_RETRIES: usize = 3;

    Ok(tool_result)
}

// ✅ Enum: PascalCase
pub enum ExecutionMode {
    // ✅ Variant: PascalCase
    Simple,
    Agent,
    GrpoRollout,
}

// ✅ Trait: PascalCase (형용사형 선호)
pub trait Executable {
    fn execute(&self) -> Result<()>;
}
```

#### 2. 에러 처리

```rust
// ✅ Good - Result와 ? 연산자 사용
pub async fn read_file(&self, path: &str) -> Result<String> {
    let content = tokio::fs::read_to_string(path).await
        .context(format!("Failed to read file: {}", path))?;

    Ok(content)
}

// ❌ Bad - unwrap() 사용
pub async fn read_file(&self, path: &str) -> String {
    tokio::fs::read_to_string(path).await.unwrap()  // 절대 금지!
}

// ✅ Good - 명확한 에러 메시지
if user_id.is_empty() {
    return Err(anyhow!(
        "User ID cannot be empty. Please provide a valid user ID."
    ));
}

// ❌ Bad - 불명확한 에러
if user_id.is_empty() {
    return Err(anyhow!("Invalid input"));
}
```

#### 3. 문서화 (Rustdoc)

```rust
/// HTTP 요청을 실행하는 도구입니다.
///
/// # 예제
///
/// ```
/// use snailer::tools::HttpTool;
///
/// let tool = HttpTool::new();
/// let result = tool.get("https://api.example.com/data").await?;
/// ```
///
/// # Errors
///
/// - 네트워크 연결 실패 시 [`std::io::Error`]를 반환합니다.
/// - 잘못된 URL 형식일 경우 [`url::ParseError`]를 반환합니다.
///
/// # Panics
///
/// 이 함수는 panic하지 않습니다.
pub async fn get(&self, url: &str) -> Result<String> {
    // ...
}

/// 사용자 설정을 관리하는 구조체
///
/// # Fields
///
/// * `user_id` - 고유한 사용자 식별자 (UUID 형식)
/// * `model` - 사용할 AI 모델 이름 (예: "claude-4.5")
/// * `max_tokens` - 최대 토큰 수 (기본값: 4096)
pub struct UserConfig {
    pub user_id: String,
    pub model: String,
    pub max_tokens: usize,
}
```

#### 4. 타입 안전성

```rust
// ✅ Good - newtype pattern으로 타입 안전성 확보
#[derive(Debug, Clone)]
pub struct UserId(String);

impl UserId {
    pub fn new(id: String) -> Result<Self> {
        if id.is_empty() {
            return Err(anyhow!("User ID cannot be empty"));
        }
        Ok(UserId(id))
    }
}

// ✅ Good - 명시적 타입
pub async fn execute(&self, user: UserId) -> Result<ExecutionResult> {
    // user는 UserId 타입으로만 받을 수 있음
}

// ❌ Bad - String 남발
pub async fn execute(&self, user: String) -> Result<String> {
    // 어떤 String인지 불명확
}
```

#### 5. 비동기 코드

```rust
// ✅ Good - 명시적 async/await
pub async fn process_tasks(&self, tasks: Vec<Task>) -> Result<Vec<TaskResult>> {
    let mut results = Vec::new();

    for task in tasks {
        let result = self.execute_task(&task).await?;
        results.push(result);
    }

    Ok(results)
}

// ✅ Better - 병렬 처리
use futures::future::join_all;

pub async fn process_tasks(&self, tasks: Vec<Task>) -> Result<Vec<TaskResult>> {
    let futures = tasks.iter().map(|task| self.execute_task(task));
    let results = join_all(futures).await;

    results.into_iter().collect()
}

// ✅ Good - timeout 설정
use tokio::time::{timeout, Duration};

pub async fn execute_with_timeout(&self) -> Result<String> {
    let result = timeout(
        Duration::from_secs(30),
        self.long_running_task()
    ).await??;  // timeout error + task error

    Ok(result)
}
```

### 코드 구조

#### 디렉토리 구조

```
src/
├── main.rs              # 엔트리포인트
├── lib.rs               # 라이브러리 루트
├── agent/               # Agent 관련
│   ├── mod.rs
│   ├── executor.rs
│   └── context.rs
├── tools/               # 도구 구현
│   ├── mod.rs
│   ├── registry.rs
│   ├── shell.rs
│   ├── file.rs
│   └── http.rs
├── api/                 # API 클라이언트
│   ├── mod.rs
│   ├── claude.rs
│   └── openai.rs
├── db/                  # 데이터베이스
│   ├── mod.rs
│   └── metrics.rs
└── utils/               # 유틸리티
    ├── mod.rs
    └── terminal.rs
```

#### 모듈 구성

```rust
// src/tools/mod.rs
mod registry;
mod shell;
mod file;
mod http;

pub use registry::ToolRegistry;
pub use shell::ShellTool;
pub use file::{FileReader, FileWriter};
pub use http::HttpTool;

// 내부용 (pub 없음)
mod internal_helper;
```

---

## 테스트 작성

### 테스트 전략

```
┌─────────────────────────────────────┐
│  1. Unit Tests (단위 테스트)         │  ← 가장 많이 작성
│     - 개별 함수/메서드 테스트         │
│     - src/ 파일 내부에 작성          │
├─────────────────────────────────────┤
│  2. Integration Tests (통합 테스트)  │  ← 핵심 흐름 검증
│     - 여러 컴포넌트 조합 테스트       │
│     - tests/ 디렉토리에 작성         │
├─────────────────────────────────────┤
│  3. Doc Tests (문서 테스트)          │  ← 예제 코드 검증
│     - Rustdoc 예제 자동 실행         │
│     - /// ``` 블록 내부              │
└─────────────────────────────────────┘
```

### 1. 단위 테스트 (Unit Tests)

```rust
// src/tools/http.rs

pub struct HttpTool {
    client: reqwest::Client,
    timeout: Duration,
}

impl HttpTool {
    pub fn new(timeout: Duration) -> Self {
        Self {
            client: reqwest::Client::new(),
            timeout,
        }
    }

    pub async fn get(&self, url: &str) -> Result<String> {
        let response = self.client
            .get(url)
            .timeout(self.timeout)
            .send()
            .await?;

        Ok(response.text().await?)
    }
}

// ✅ 같은 파일 하단에 테스트 모듈
#[cfg(test)]
mod tests {
    use super::*;
    use tokio;

    #[tokio::test]
    async fn test_http_get_success() {
        let tool = HttpTool::new(Duration::from_secs(10));
        let result = tool.get("https://httpbin.org/get").await;

        assert!(result.is_ok());
    }

    #[tokio::test]
    async fn test_http_timeout() {
        let tool = HttpTool::new(Duration::from_millis(1));
        let result = tool.get("https://httpbin.org/delay/10").await;

        assert!(result.is_err());
        assert!(result.unwrap_err().to_string().contains("timeout"));
    }

    #[tokio::test]
    async fn test_http_invalid_url() {
        let tool = HttpTool::new(Duration::from_secs(10));
        let result = tool.get("not-a-valid-url").await;

        assert!(result.is_err());
    }
}
```

### 2. 통합 테스트 (Integration Tests)

```rust
// tests/agent_integration_test.rs

use snailer::Agent;
use std::path::PathBuf;

#[tokio::test]
async fn test_agent_executes_shell_command() {
    let mut agent = Agent::new(
        "List files in current directory".to_string(),
        PathBuf::from("."),
        "claude-4.5".to_string()
    ).unwrap();

    // Mock API 응답 설정 (실제 API 호출 안 함)
    agent.set_mock_response(r#"{
        "content": [{
            "type": "tool_use",
            "name": "shell",
            "input": {"command": "ls"}
        }]
    }"#);

    let result = agent.run_agent_mode().await;

    assert!(result.is_ok());
    assert!(agent.tool_calls_count() > 0);
}

#[tokio::test]
async fn test_agent_handles_cancellation() {
    let mut agent = Agent::new(
        "Long running task".to_string(),
        PathBuf::from("."),
        "claude-4.5".to_string()
    ).unwrap();

    // 1초 후 취소
    tokio::spawn(async move {
        tokio::time::sleep(Duration::from_secs(1)).await;
        agent.cancel();
    });

    let result = agent.run_agent_mode().await;

    assert!(result.is_ok());
    assert!(agent.was_cancelled());
}
```

### 3. 문서 테스트 (Doc Tests)

```rust
/// HTTP GET 요청을 수행합니다.
///
/// # 예제
///
/// ```
/// use snailer::tools::HttpTool;
/// use tokio::time::Duration;
///
/// # tokio_test::block_on(async {
/// let tool = HttpTool::new(Duration::from_secs(10));
/// let html = tool.get("https://example.com").await?;
/// assert!(html.contains("Example Domain"));
/// # Ok::<(), anyhow::Error>(())
/// # });
/// ```
pub async fn get(&self, url: &str) -> Result<String> {
    // ...
}
```

### 테스트 커버리지

```bash
# 커버리지 측정
cargo tarpaulin --out Html --output-dir coverage

# 브라우저에서 확인
open coverage/index.html
```

**목표 커버리지**:
- 🎯 **핵심 로직**: 80% 이상
- 🎯 **도구 구현**: 70% 이상
- 🎯 **유틸리티**: 60% 이상

---

## Pull Request 프로세스

### PR 생성 전 체크리스트

```bash
# 1. 최신 main 브랜치 머지
git checkout main
git pull upstream main
git checkout feat/123-add-http-tool
git merge main

# 2. 코드 품질 확인
cargo fmt
cargo clippy -- -D warnings
cargo test

# 3. 문서 확인
cargo doc --no-deps --open

# 4. 커밋 정리 (필요시)
git rebase -i main
```

### PR 템플릿

```markdown
## 📝 변경 사항 요약

간결하게 무엇을 변경했는지 설명해주세요.

## 🔗 관련 이슈

Closes #123

## 🎯 변경 유형

- [ ] 🐛 버그 수정
- [ ] ✨ 새 기능
- [ ] 📝 문서 업데이트
- [ ] ♻️ 리팩토링
- [ ] ⚡ 성능 개선
- [ ] 🧪 테스트 추가

## 🧪 테스트 방법

어떻게 테스트했는지 설명해주세요:

1. `cargo test` 실행
2. 수동 테스트: ...
3. 엣지 케이스 확인: ...

## 📸 스크린샷 (UI 변경인 경우)

Before / After 스크린샷

## ✅ 체크리스트

- [ ] 코드가 `cargo fmt`로 포맷되었습니다
- [ ] `cargo clippy`를 통과했습니다
- [ ] 모든 테스트가 통과했습니다 (`cargo test`)
- [ ] 새로운 기능에 대한 테스트를 추가했습니다
- [ ] 문서를 업데이트했습니다
- [ ] CHANGELOG.md를 업데이트했습니다 (해당하는 경우)

## 💬 추가 설명

리뷰어가 알아야 할 추가 정보나 질문이 있다면 작성해주세요.
```

### PR 크기 가이드

| 크기 | 변경 라인 수 | 리뷰 시간 | 권장 사항 |
|-----|------------|----------|----------|
| 🟢 **Small** | < 100 | 10분 | 이상적 ✅ |
| 🟡 **Medium** | 100-300 | 30분 | 괜찮음 |
| 🟠 **Large** | 300-500 | 1시간 | 나누는 것 고려 |
| 🔴 **Huge** | > 500 | 2시간+ | 반드시 나누기 ❌ |

**큰 PR 나누는 방법**:
```
# 예: HTTP 도구 추가 (500줄)

PR 1: feat: add HTTP client basic structure (100줄)
PR 2: feat: add HTTP retry logic (150줄)
PR 3: feat: add HTTP authentication (100줄)
PR 4: test: add HTTP integration tests (150줄)
```

---

## 코드 리뷰

### 리뷰어 가이드

**리뷰 시 확인 사항**:

1. **정확성 (Correctness)**
   - [ ] 코드가 의도한 대로 동작하는가?
   - [ ] 엣지 케이스를 처리하는가?
   - [ ] 에러 처리가 적절한가?

2. **설계 (Design)**
   - [ ] 코드 구조가 합리적인가?
   - [ ] 적절한 추상화 수준인가?
   - [ ] 재사용 가능한가?

3. **가독성 (Readability)**
   - [ ] 변수/함수 이름이 명확한가?
   - [ ] 주석이 필요한 곳에 있는가?
   - [ ] 코드가 자기 설명적인가?

4. **테스트 (Testing)**
   - [ ] 충분한 테스트가 있는가?
   - [ ] 테스트가 의미 있는가?
   - [ ] 실패 케이스를 테스트하는가?

5. **문서 (Documentation)**
   - [ ] Public API에 문서가 있는가?
   - [ ] 예제 코드가 있는가?
   - [ ] README가 업데이트되었는가?

### 리뷰 코멘트 스타일

**✅ 좋은 리뷰 코멘트**:

```markdown
**[성능]** 이 루프는 매번 HashMap을 할당합니다.
루프 밖으로 빼면 어떨까요?

Before:
for item in items {
    let mut map = HashMap::new();
    // ...
}

After:
let mut map = HashMap::new();
for item in items {
    map.clear();
    // ...
}
```

```markdown
**[질문]** 왜 여기서 `unwrap()`을 사용하셨나요?
이 함수가 실패할 가능성이 있다면 `?`를 사용하는 게
더 좋을 것 같습니다.
```

```markdown
**[칭찬]** 이 추상화 정말 깔끔하네요! 테스트하기도
훨씬 쉬워졌습니다. 👍
```

**❌ 나쁜 리뷰 코멘트**:

```markdown
❌ "이거 안 좋은데요."  (이유 없음)
❌ "이렇게 하지 마세요."  (대안 없음)
❌ "누가 이렇게 코드를 짜요?"  (불친절)
```

### 리뷰 라벨

- `LGTM` (Looks Good To Me) - 승인
- `nit` - 사소한 제안 (블로킹 아님)
- `question` - 질문
- `blocker` - 반드시 수정 필요

---

## 커뮤니티 가이드라인

### 질문하기

**좋은 질문**:
```markdown
## 질문: Agent 컨텍스트 압축 동작 방식

안녕하세요! Agent의 컨텍스트 압축 기능을 이해하려고 합니다.

**현재 이해**:
- `compact_context()`가 오래된 대화를 압축한다
- 최근 N개 메시지는 유지된다

**질문**:
1. N의 기본값은 몇 개인가요?
2. 압축 시 AI를 호출하는데, 비용은 어떻게 되나요?
3. 압축된 내용은 어디에 저장되나요?

**시도한 것**:
- 코드를 읽어봤지만 압축 로직이 복잡해서 확신이 없습니다
- 문서를 찾아봤지만 상세 설명이 없었습니다

감사합니다!
```

### 이슈 보고하기

**버그 리포트 템플릿**:

```markdown
## 🐛 버그 설명

Agent가 특정 파일을 읽을 때 메모리가 계속 증가합니다.

## 재현 방법

1. 10MB 이상의 파일 생성
2. `snailer --agent --prompt "파일 내용 요약해줘"`
3. 메모리 사용량 모니터링

## 예상 동작

파일을 읽은 후 메모리가 해제되어야 합니다.

## 실제 동작

메모리 사용량이 계속 증가합니다 (10MB → 50MB).

## 환경

- OS: macOS 14.0
- Rust 버전: 1.75.0
- Snailer 버전: 0.1.14
- 모델: claude-4.5

## 로그

RUST_LOG=debug snailer ...
[2025-01-15 10:30:00] DEBUG Reading file: large.txt
[2025-01-15 10:30:05] DEBUG Memory: 50MB
...

## 추가 정보

Activity Monitor 스크린샷 첨부
```

### 멘토링 & 도움 주기

**초보자를 도울 때**:
- ✅ 인내심을 가지세요
- ✅ "바보같은 질문은 없습니다"
- ✅ 문서 링크를 제공하세요
- ✅ 예제 코드를 보여주세요
- ❌ "이건 너무 쉬운데요" 같은 말 하지 마세요

**도움 요청할 때**:
- ✅ 스스로 먼저 시도하세요
- ✅ 무엇을 시도했는지 설명하세요
- ✅ 구체적으로 질문하세요
- ❌ "안 돼요. 도와주세요" 만 쓰지 마세요

---

## 고급 주제

### 성능 프로파일링

```bash
# CPU 프로파일링
cargo build --release
perf record --call-graph=dwarf ./target/release/snailer
perf report

# 메모리 프로파일링
valgrind --tool=massif ./target/release/snailer
```

### 벤치마킹

```rust
// benches/agent_benchmark.rs
use criterion::{black_box, criterion_group, criterion_main, Criterion};
use snailer::Agent;

fn bench_agent_execution(c: &mut Criterion) {
    c.bench_function("agent simple mode", |b| {
        b.iter(|| {
            let mut agent = Agent::new(
                black_box("Hello".to_string()),
                PathBuf::from("."),
                "claude-4.5".to_string()
            ).unwrap();

            agent.run_simple_mode()
        });
    });
}

criterion_group!(benches, bench_agent_execution);
criterion_main!(benches);
```

### Unsafe 코드

```rust
// ⚠️ Unsafe 코드는 최후의 수단입니다
// 반드시 리뷰어와 논의 후 사용하세요

// ✅ Good - 이유와 안전성 설명
/// SAFETY: ptr은 항상 유효한 메모리를 가리키며,
/// lifetime 'a는 데이터가 살아있음을 보장합니다.
unsafe fn read_ptr<'a>(ptr: *const u8) -> &'a u8 {
    &*ptr
}

// ❌ Bad - 설명 없는 unsafe
unsafe fn do_something(ptr: *const u8) {
    // ...
}
```

---

## 릴리스 프로세스

### 버전 관리 (Semantic Versioning)

```
MAJOR.MINOR.PATCH

MAJOR: 호환성 깨는 변경 (Breaking Changes)
MINOR: 새 기능 추가 (Backward Compatible)
PATCH: 버그 수정
```

**예시**:
- `0.1.14 → 0.1.15`: 버그 수정
- `0.1.15 → 0.2.0`: 새 기능 추가
- `0.2.0 → 1.0.0`: 정식 릴리스
- `1.0.0 → 2.0.0`: Breaking change

### CHANGELOG 작성

```markdown
# Changelog

## [0.2.0] - 2025-01-20

### Added
- HTTP 도구 추가 (#123)
- 컨텍스트 자동 압축 기능 (#145)

### Changed
- Agent 실행 루프 성능 30% 개선 (#134)
- 에러 메시지 개선 (#156)

### Fixed
- 메모리 누수 수정 (#167)
- Windows에서 파일 경로 문제 해결 (#178)

### Deprecated
- `old_api()` 대신 `new_api()` 사용 권장

### Removed
- 실험적 GRPO 모드 제거 (별도 브랜치로 이동)

### Security
- 의존성 보안 업데이트: tokio 1.35.0 → 1.36.0
```

---

## 자주 묻는 질문 (FAQ)

### Q: 첫 기여로 무엇을 하면 좋을까요?

**A**: `good-first-issue` 라벨을 찾아보세요:
1. 문서 오타 수정
2. 예제 코드 추가
3. 테스트 추가
4. 간단한 버그 수정

### Q: 코드 리뷰가 오래 걸리는데 어떻게 하나요?

**A**:
- 보통 2-3일 내 리뷰됩니다
- 1주일 이상 걸리면 친절하게 핑(ping) 해주세요
- Discord에서 리마인더 보내주세요

### Q: 제 PR이 거절당했어요. 어떡하죠?

**A**:
- 거절 사유를 읽어보세요
- 질문이 있으면 코멘트로 물어보세요
- 수정 후 다시 제출하세요
- 모든 거절은 배움의 기회입니다!

### Q: Breaking change는 어떻게 처리하나요?

**A**:
1. 먼저 이슈를 열어 논의하세요
2. Deprecation 기간을 두세요 (1-2 릴리스)
3. Migration 가이드를 작성하세요
4. CHANGELOG에 명확히 표시하세요

---

## 리소스

### 공식 문서
- [Rust Book](https://doc.rust-lang.org/book/) - Rust 기초
- [Async Book](https://rust-lang.github.io/async-book/) - 비동기 프로그래밍
- [Cargo Book](https://doc.rust-lang.org/cargo/) - 패키지 관리

### 코딩 스타일
- [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Google Engineering Practices](https://google.github.io/eng-practices/)

### Snailer 문서
- [Agent Architecture](./AGENT_ARCHITECTURE.md)
- [Tool System](./TOOL_SYSTEM.md)
- [ACE System](./ACE_SYSTEM.md)

---

## 라이선스

이 프로젝트에 기여함으로써, 귀하의 기여가 프로젝트와 동일한 MIT 라이선스 하에 배포되는 것에 동의하게 됩니다.

---

<div align="center">

**🙏 기여해주셔서 감사합니다!**

모든 기여는 Snailer를 더 나은 도구로 만듭니다.

[Website](https://snailer.ai) • [Documentation](./README.md) • [Issues](https://github.com/your-org/snailer/issues)

</div>
