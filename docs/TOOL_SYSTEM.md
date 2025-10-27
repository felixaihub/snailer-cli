# Snailer Tool System

> 🔧 **목적**: Snailer Agent가 사용하는 도구 시스템의 구조와 확장 방법을 설명합니다.

## 📚 목차

1. [개요](#개요)
2. [도구 구조](#도구-구조)
3. [내장 도구 목록](#내장-도구-목록)
4. [도구 실행 흐름](#도구-실행-흐름)
5. [새로운 도구 추가하기](#새로운-도구-추가하기)
6. [모범 사례](#모범-사례)

---

## 개요

Snailer의 도구 시스템은 AI 에이전트가 **파일 시스템, Git, 셸 명령** 등과 상호작용할 수 있게 해주는 핵심 컴포넌트입니다.

### 핵심 원칙

1. **선언적 정의**: JSON Schema로 도구의 입력을 명확하게 정의
2. **타입 안전성**: Rust의 타입 시스템을 활용한 안전한 실행
3. **에러 핸들링**: 모든 도구는 Result<String>을 반환하여 에러 전파
4. **AI 친화적**: AI가 이해하기 쉬운 설명과 명확한 파라미터

---

## 도구 구조

### 1. Tool 정의

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Tool {
    pub name: String,           // 도구 이름 (예: "read_file")
    pub description: String,    // 도구 설명 (AI가 읽음)
    pub input_schema: Value,    // JSON Schema 형식의 입력 스키마
}
```

### 2. ToolUse (도구 호출)

AI가 도구를 호출할 때 사용하는 구조:

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ToolUse {
    pub id: String,             // 고유 ID (AI가 생성)
    pub tool_type: String,      // "tool_use" (고정값)
    pub name: String,           // 도구 이름
    pub input: Value,           // 입력 파라미터 (JSON)
}
```

### 3. ToolResult (도구 결과)

도구 실행 후 AI에게 반환하는 구조:

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ToolResult {
    pub tool_use_id: String,    // ToolUse의 ID와 매칭
    pub result_type: String,    // "tool_result" (고정값)
    pub content: String,        // 결과 내용
    pub is_error: Option<bool>, // 에러 여부 (true면 에러)
}
```

### 4. ToolRegistry

모든 도구를 관리하는 레지스트리:

```rust
pub struct ToolRegistry {
    pub project_path: PathBuf,  // 작업 디렉토리
    tools: Vec<Tool>,           // 사용 가능한 도구 목록
}

impl ToolRegistry {
    // 새 레지스트리 생성
    pub fn new(project_path: PathBuf) -> Self

    // 사용 가능한 도구 목록 반환
    pub fn get_tools(&self) -> Vec<Tool>

    // 도구 실행
    pub fn execute_tool(&self, tool_use: &ToolUse) -> ToolResult
}
```

---

## 내장 도구 목록

### 🔍 Discovery Tools (탐색 도구)

#### 1. read_file

**설명**: 파일 내용을 읽습니다. 선택적으로 라인 범위 지정 가능.

**파라미터**:
```json
{
  "path": "src/main.rs",     // 필수: 파일 경로
  "start": 10,               // 선택: 시작 라인 (1-indexed)
  "end": 50                  // 선택: 끝 라인 (포함)
}
```

**예시 응답**:
```
    10  fn main() {
    11      println!("Hello");
    12  }
```

**구현 위치**: `tool_read_file()`

---

#### 2. search_repo

**설명**: ripgrep으로 코드 검색 (.gitignore 존중)

**파라미터**:
```json
{
  "query": "async fn",          // 필수: 검색 패턴 (regex 지원)
  "file_pattern": "*.rs"        // 선택: 파일 패턴
}
```

**예시 응답**:
```
src/main.rs:45:pub async fn run() -> Result<()> {
src/agent.rs:120:async fn execute_tool_loop(&mut self) {
```

**구현 위치**: `tool_search_repo()`

---

#### 3. find_files

**설명**: 파일명 패턴으로 파일 찾기

**파라미터**:
```json
{
  "pattern": "*.toml"           // 필수: 파일 패턴
}
```

**예시 응답**:
```
Cargo.toml
packages/snailer-cli/Cargo.toml
```

**구현 위치**: `tool_find_files()`

---

### ✏️ Editing Tools (편집 도구)

#### 4. edit_file

**설명**: 파일에서 old_text를 new_text로 교체 (간단하고 신뢰성 높음)

**파라미터**:
```json
{
  "path": "src/main.rs",
  "old_text": "println!(\"Hello\");",
  "new_text": "println!(\"Hello, World!\");"
}
```

**특징**:
- 정확한 문자열 매칭 (공백, 들여쓰기 포함)
- 한 번만 교체 (안전성)
- 실패 시 명확한 에러 메시지

**구현 위치**: `tool_edit_file()`

---

#### 5. write_file

**설명**: 새 파일 생성 또는 기존 파일 덮어쓰기

**파라미터**:
```json
{
  "path": "src/new_module.rs",
  "content": "pub fn hello() { println!(\"Hello\"); }"
}
```

**주의**:
- 기존 파일을 덮어쓰므로 주의 필요
- AI가 신중하게 사용하도록 설명 필요

**구현 위치**: `tool_write_file()`

---

#### 6. create_file_with_edits

**설명**: 여러 블록을 조합하여 새 파일 생성 (복잡한 파일 생성용)

**파라미터**:
```json
{
  "path": "src/complex.rs",
  "edits": [
    {
      "type": "create",
      "content": "// File header\n"
    },
    {
      "type": "insert_after",
      "marker": "// File header",
      "content": "use std::fs;"
    }
  ]
}
```

**특징**:
- 복잡한 파일 구조 생성에 유용
- 여러 편집 작업을 원자적으로 수행

**구현 위치**: `tool_create_file_with_edits()`

---

### 🗂️ File Management Tools

#### 7. delete_file

**설명**: 파일 삭제 (신중하게 사용)

**파라미터**:
```json
{
  "path": "temp_file.txt"
}
```

**안전 장치**:
- 중요한 파일 삭제 시 AI에게 경고
- 실수 방지를 위한 확인 로직

**구현 위치**: `tool_delete_file()`

---

#### 8. move_file

**설명**: 파일 이동/이름 변경

**파라미터**:
```json
{
  "source": "old_name.rs",
  "destination": "new_name.rs"
}
```

**구현 위치**: `tool_move_file()`

---

### 📋 Directory Tools

#### 9. list_directory

**설명**: 디렉토리 내용 나열

**파라미터**:
```json
{
  "path": "src/",              // 선택: 경로 (기본값: 프로젝트 루트)
  "recursive": false           // 선택: 재귀적 탐색
}
```

**예시 응답**:
```
src/
  main.rs
  agent.rs
  tools.rs
  api.rs
```

**구현 위치**: `tool_list_directory()`

---

### 🐚 Shell Tools

#### 10. shell_command

**설명**: 셸 명령 실행 (신중하게 사용)

**파라미터**:
```json
{
  "command": "cargo build --release",
  "timeout": 60000             // 선택: 타임아웃 (ms)
}
```

**보안 고려사항**:
- 위험한 명령 필터링
- 사용자 승인 필요 (향후 추가)
- 타임아웃 설정

**구현 위치**: `tool_shell_command()`

---

## 도구 실행 흐름

### 전체 흐름

```
┌──────────────────────────────────────────────────────────────┐
│ 1. AI가 Tool Use 생성                                         │
│    {                                                          │
│      "type": "tool_use",                                      │
│      "id": "toolu_123",                                       │
│      "name": "read_file",                                     │
│      "input": {"path": "src/main.rs"}                         │
│    }                                                          │
└────────────────┬─────────────────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────────────────────┐
│ 2. ToolRegistry::execute_tool() 호출                          │
│    - 도구 이름으로 라우팅                                      │
│    - match tool_use.name { ... }                              │
└────────────────┬─────────────────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────────────────────┐
│ 3. 개별 도구 함수 실행                                         │
│    fn tool_read_file(&self, input: &Value) -> Result<String> │
│    {                                                          │
│      // 1. 파라미터 파싱                                       │
│      let path = input["path"].as_str()?;                      │
│                                                               │
│      // 2. 검증                                               │
│      if !path.exists() {                                      │
│        return Err(anyhow!("File not found"));                 │
│      }                                                        │
│                                                               │
│      // 3. 실행                                               │
│      let content = fs::read_to_string(path)?;                 │
│                                                               │
│      // 4. 결과 반환                                          │
│      Ok(content)                                              │
│    }                                                          │
└────────────────┬─────────────────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────────────────────┐
│ 4. ToolResult 생성                                            │
│    {                                                          │
│      "type": "tool_result",                                   │
│      "tool_use_id": "toolu_123",                              │
│      "content": "fn main() { ... }",                          │
│      "is_error": false                                        │
│    }                                                          │
└────────────────┬─────────────────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────────────────────┐
│ 5. AI에게 결과 반환                                           │
│    - conversation_history에 추가                              │
│    - AI가 결과를 보고 다음 행동 결정                           │
└──────────────────────────────────────────────────────────────┘
```

### 에러 처리

```rust
pub fn execute_tool(&self, tool_use: &ToolUse) -> ToolResult {
    let result_content = match tool_use.name.as_str() {
        "read_file" => self.tool_read_file(&tool_use.input),
        "write_file" => self.tool_write_file(&tool_use.input),
        _ => Err(anyhow!("Unknown tool: {}", tool_use.name)),
    };

    match result_content {
        Ok(content) => ToolResult {
            tool_use_id: tool_use.id.clone(),
            result_type: "tool_result".to_string(),
            content,
            is_error: None,  // 성공
        },
        Err(e) => ToolResult {
            tool_use_id: tool_use.id.clone(),
            result_type: "tool_result".to_string(),
            content: format!("Error: {}", e),
            is_error: Some(true),  // 에러 표시
        },
    }
}
```

**특징**:
- 모든 에러를 캐치하여 AI에게 전달
- AI가 에러를 보고 재시도 또는 대안 선택
- 시스템 크래시 방지

---

## 새로운 도구 추가하기

### Step 1: 도구 정의 추가

`define_tools()` 함수에 새 도구 추가:

```rust
fn define_tools() -> Vec<Tool> {
    vec![
        // ... 기존 도구들 ...

        // 새 도구: HTTP 요청
        Tool {
            name: "http_request".to_string(),
            description: "Make HTTP GET/POST request to external API".to_string(),
            input_schema: json!({
                "type": "object",
                "required": ["url"],
                "properties": {
                    "url": {
                        "type": "string",
                        "description": "The URL to request"
                    },
                    "method": {
                        "type": "string",
                        "description": "HTTP method (GET/POST)",
                        "enum": ["GET", "POST"]
                    },
                    "body": {
                        "type": "string",
                        "description": "Request body (for POST)"
                    }
                }
            }),
        },
    ]
}
```

### Step 2: 도구 구현

개별 도구 함수 구현:

```rust
fn tool_http_request(&self, input: &Value) -> Result<String> {
    // 1. 파라미터 파싱
    let url = input["url"]
        .as_str()
        .ok_or_else(|| anyhow!("Missing 'url' parameter"))?;

    let method = input["method"]
        .as_str()
        .unwrap_or("GET");

    // 2. 검증
    if !url.starts_with("http://") && !url.starts_with("https://") {
        return Err(anyhow!("Invalid URL scheme"));
    }

    // 3. 실행
    let response = match method {
        "GET" => reqwest::blocking::get(url)?,
        "POST" => {
            let body = input["body"].as_str().unwrap_or("");
            reqwest::blocking::Client::new()
                .post(url)
                .body(body.to_string())
                .send()?
        }
        _ => return Err(anyhow!("Unsupported method: {}", method)),
    };

    // 4. 결과 반환
    let status = response.status();
    let body = response.text()?;

    Ok(format!("Status: {}\n\n{}", status, body))
}
```

### Step 3: 라우팅 추가

`execute_tool()` 함수에 라우팅 추가:

```rust
pub fn execute_tool(&self, tool_use: &ToolUse) -> ToolResult {
    let result_content = match tool_use.name.as_str() {
        "read_file" => self.tool_read_file(&tool_use.input),
        "write_file" => self.tool_write_file(&tool_use.input),
        "http_request" => self.tool_http_request(&tool_use.input),  // ← 추가
        _ => Err(anyhow!("Unknown tool: {}", tool_use.name)),
    };

    // ... 에러 처리 ...
}
```

### Step 4: 테스트 작성

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_http_request_tool() {
        let registry = ToolRegistry::new(PathBuf::from("."));

        let tool_use = ToolUse {
            id: "test_123".to_string(),
            tool_type: "tool_use".to_string(),
            name: "http_request".to_string(),
            input: json!({
                "url": "https://api.github.com",
                "method": "GET"
            }),
        };

        let result = registry.execute_tool(&tool_use);
        assert!(result.is_error.is_none());
        assert!(result.content.contains("Status:"));
    }
}
```

---

## 모범 사례

### ✅ Do's (권장)

1. **명확한 설명 작성**
```rust
Tool {
    name: "search_files".to_string(),
    description: "Search for files by name pattern. Use glob patterns like *.rs or Config*.json".to_string(),
    // ↑ AI가 언제 사용할지 명확히 알 수 있음
}
```

2. **타입 검증**
```rust
fn tool_example(&self, input: &Value) -> Result<String> {
    // ✅ Good: 명시적 에러 메시지
    let path = input["path"]
        .as_str()
        .ok_or_else(|| anyhow!("Missing required parameter 'path'"))?;

    // ❌ Bad: panic 발생 가능
    // let path = input["path"].as_str().unwrap();
}
```

3. **경로 검증**
```rust
fn tool_read_file(&self, input: &Value) -> Result<String> {
    let path = input["path"].as_str()?;
    let full_path = self.project_path.join(path);

    // ✅ 프로젝트 경로 밖으로 벗어나지 않는지 검증
    if !full_path.starts_with(&self.project_path) {
        return Err(anyhow!("Path escapes project directory"));
    }

    fs::read_to_string(full_path)
}
```

4. **타임아웃 설정**
```rust
fn tool_shell_command(&self, input: &Value) -> Result<String> {
    let timeout = input["timeout"]
        .as_u64()
        .unwrap_or(30000);  // ✅ 기본값 30초

    // 타임아웃 적용 로직
}
```

### ❌ Don'ts (비권장)

1. **무제한 리소스 사용**
```rust
// ❌ Bad: 파일 크기 제한 없음
fn tool_read_file(&self, input: &Value) -> Result<String> {
    let content = fs::read_to_string(path)?;  // 100GB 파일도 읽음
    Ok(content)
}

// ✅ Good: 크기 제한
fn tool_read_file(&self, input: &Value) -> Result<String> {
    let metadata = fs::metadata(path)?;
    if metadata.len() > 10_000_000 {  // 10MB 제한
        return Err(anyhow!("File too large"));
    }
    let content = fs::read_to_string(path)?;
    Ok(content)
}
```

2. **민감한 정보 노출**
```rust
// ❌ Bad: 에러에 민감한 정보 포함
Err(anyhow!("Failed to read /home/user/.env: {}", e))

// ✅ Good: 일반적인 에러 메시지
Err(anyhow!("Failed to read file: permission denied"))
```

3. **위험한 명령 필터링 없음**
```rust
// ❌ Bad: 모든 명령 허용
fn tool_shell_command(&self, input: &Value) -> Result<String> {
    let command = input["command"].as_str()?;
    Command::new("sh").arg("-c").arg(command).output()?;
}

// ✅ Good: 위험한 명령 차단
fn tool_shell_command(&self, input: &Value) -> Result<String> {
    let command = input["command"].as_str()?;

    // 위험한 명령 차단
    if command.contains("rm -rf /") {
        return Err(anyhow!("Dangerous command blocked"));
    }

    Command::new("sh").arg("-c").arg(command).output()?;
}
```

---

## 성능 최적화

### 1. 결과 크기 제한

```rust
fn tool_search_repo(&self, input: &Value) -> Result<String> {
    let output = Command::new("rg")
        .args(["--max-count", "100"])  // ✅ 최대 100개 결과
        .output()?;

    Ok(String::from_utf8_lossy(&output.stdout).to_string())
}
```

### 2. 캐싱

```rust
use std::collections::HashMap;
use std::sync::Mutex;

lazy_static! {
    static ref FILE_CACHE: Mutex<HashMap<String, String>> = Mutex::new(HashMap::new());
}

fn tool_read_file(&self, input: &Value) -> Result<String> {
    let path = input["path"].as_str()?;

    // 캐시 확인
    if let Some(cached) = FILE_CACHE.lock().unwrap().get(path) {
        return Ok(cached.clone());
    }

    // 파일 읽기
    let content = fs::read_to_string(path)?;

    // 캐시 저장
    FILE_CACHE.lock().unwrap().insert(path.to_string(), content.clone());

    Ok(content)
}
```

---

## 보안 고려사항

### 1. 경로 탐색 공격 방지

```rust
fn validate_path(&self, path: &str) -> Result<PathBuf> {
    let full_path = self.project_path.join(path).canonicalize()?;

    if !full_path.starts_with(&self.project_path) {
        return Err(anyhow!("Path traversal detected"));
    }

    Ok(full_path)
}
```

### 2. 명령 인젝션 방지

```rust
fn tool_shell_command(&self, input: &Value) -> Result<String> {
    let command = input["command"].as_str()?;

    // 허용된 명령만 실행
    let allowed_commands = ["cargo", "npm", "git"];
    let cmd = command.split_whitespace().next().unwrap_or("");

    if !allowed_commands.contains(&cmd) {
        return Err(anyhow!("Command not allowed: {}", cmd));
    }

    Command::new("sh").arg("-c").arg(command).output()?;
}
```

### 3. 리소스 제한

```rust
use std::time::Duration;

fn tool_with_timeout(&self, input: &Value) -> Result<String> {
    let timeout = Duration::from_secs(30);

    let result = std::panic::catch_unwind(|| {
        // 실제 작업
    });

    result.map_err(|_| anyhow!("Operation timed out"))?
}
```

---

## 디버깅

### 로깅 추가

```rust
fn tool_read_file(&self, input: &Value) -> Result<String> {
    let path = input["path"].as_str()?;

    log::debug!("Reading file: {}", path);

    let content = fs::read_to_string(path)?;

    log::debug!("File read successfully: {} bytes", content.len());

    Ok(content)
}
```

### 실행 시간 측정

```rust
use std::time::Instant;

fn tool_search_repo(&self, input: &Value) -> Result<String> {
    let start = Instant::now();

    let result = /* ... 실제 작업 ... */;

    log::info!("Search completed in {:?}", start.elapsed());

    result
}
```

---

## 다음 단계

- [에이전트 아키텍처](./AGENT_ARCHITECTURE.md)
- [ACE 컨텍스트 관리](./ACE_SYSTEM.md)
- [기여 가이드](./CONTRIBUTING.md)

---

## 라이선스

MIT License
