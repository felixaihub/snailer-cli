# Experimental Features

> 🧪 **실험 중** - 연구 중이거나 향후 구현 예정인 기능들

## ⚠️ 주의사항

이 디렉토리의 문서들은:
- 🔬 **실험적** - 현재 프로덕션에서 사용되지 않음
- 📋 **계획 단계** - 향후 구현 가능성 있음
- 🧠 **연구 목적** - 아이디어 탐색 및 개념 검증

**이 기능들은 아직 안정적이지 않으며, 언제든지 변경되거나 제거될 수 있습니다.**

---

## 📁 디렉토리 구조

### [prompts/](./prompts/)
- **VS_PROMPTS.md** - Verification/Selection 프롬프트 개념

---

## 🧪 실험 기능 상태

### VS Prompts
- **상태**: 🧪 개념만 사용
- **설명**: VS (Verification/Selection) 블록의 개념적 설명
- **실제 구현**:
  - ✅ VS 블록 자체는 `src/agent.rs`에 완전 구현됨
  - ❌ 이 문서의 템플릿 파일은 로드되지 않음
  - 💡 실제 프롬프트는 코드에 하드코딩되어 있음
- **참조**: `src/agent.rs` lines 1280-1364 (`create_user_prompt()`, `create_system_prompt()`)

---

## 🔬 왜 Experimental인가?

### 하드코딩 vs. 템플릿 시스템

**현재 (하드코딩)**:
```rust
fn create_user_prompt(&self) -> String {
    format!(r#"
<<<VS_START>>>
## DOMAIN_GUIDANCE
...
<<<VS_END>>>
"#)
}
```

**향후 계획 (템플릿 시스템)**:
```rust
fn load_prompt_template(domain: &str, lang: &str) -> String {
    include_str!(format!("templates/vs_{}_{}.txt", domain, lang))
}
```

현재는 성능과 단순성을 위해 하드코딩 방식을 사용하지만, 향후 다국어 지원과 도메인별 커스터마이징을 위해 템플릿 시스템을 도입할 수 있습니다.

---

## 🚀 기여하기

### 실험 기능 제안
1. [GitHub Issues](https://github.com/your-org/snailer/issues)에 제안서 작성
2. 프로토타입 구현 (optional)
3. 벤치마크 결과 공유 (optional)
4. Pull Request 제출

### 실험 기능을 프로덕션으로
실험 기능을 메인 구현으로 승격시키려면:
1. 성능 벤치마크 통과
2. 테스트 커버리지 80% 이상
3. 문서 업데이트
4. 코어 팀 리뷰

자세한 내용은 [CONTRIBUTING.md](../CONTRIBUTING.md)를 참고하세요.

---

## 📊 타임라인

| 기능 | 제안 날짜 | 상태 | 목표 릴리스 |
|-----|---------|------|-----------|
| VS Prompts Templates | 2025-10-20 | 🧪 Research | TBD |
| Domain Presets | 2025-10-20 | 📋 Planned | v0.2.0 |

---

## 🔗 관련 문서

- [DOCUMENTATION_STATUS.md](../DOCUMENTATION_STATUS.md) - 전체 구현 상태
- [AGENT_ARCHITECTURE.md](../AGENT_ARCHITECTURE.md) - 현재 프로덕션 아키텍처
- [CONTRIBUTING.md](../CONTRIBUTING.md) - 기여 가이드

---

**실험을 두려워하지 마세요! 🚀**

새로운 아이디어는 언제나 환영합니다. 실패해도 괜찮습니다 - 그것도 배움입니다!
