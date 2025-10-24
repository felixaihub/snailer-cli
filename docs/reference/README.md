# Reference Documentation

> 📚 **참고 자료** - 현재 구현에서 직접 로드되지 않지만, 개념적으로 유용한 참고 문서들

## 📋 이 디렉토리의 목적

이 디렉토리의 문서들은:
- ✅ **개념적으로 유효함** - 설계 원칙과 아이디어가 실제 구현에 영향을 줌
- ⚠️ **직접 로드 안 됨** - 코드에서 `include_str!()` 등으로 로드하지 않음
- 📖 **교육용** - 기여자와 연구자를 위한 참고 자료

## 📄 문서 목록

### [NEXT_ACTION_DSL.md](./NEXT_ACTION_DSL.md)
- **설명**: NEXT_ACTION DSL 문법 참조
- **실제 구현**: VS 블록 내부의 `## NEXT_ACTION` 섹션으로 구현됨
- **위치**: `src/agent.rs` `parse_vs_lite_block()` 함수
- **상태**: ✅ 개념 사용됨, 하드코딩됨

### [runbook.md](./runbook.md)
- **설명**: 운영 절차 및 문제 해결 가이드
- **실제 구현**: 문서 전용
- **상태**: 📖 운영 문서

### [safety-approval.md](./safety-approval.md)
- **설명**: 안전 및 승인 가이드라인
- **실제 구현**: 문서 전용
- **상태**: 📖 정책 문서

---

## 🔗 관련 문서

실제 구현된 시스템에 대해서는 다음 문서를 참고하세요:
- [AGENT_ARCHITECTURE.md](../AGENT_ARCHITECTURE.md) - VS 블록과 NEXT_ACTION 실제 구현
- [DOCUMENTATION_STATUS.md](../DOCUMENTATION_STATUS.md) - 구현 상태 전체 분석

---

## 🤝 기여하기

이 참고 문서를 개선하고 싶다면:
1. 실제 구현과의 차이를 명확히 표시
2. 예제 코드 추가
3. 관련 논문이나 외부 자료 링크 추가

자세한 내용은 [CONTRIBUTING.md](../CONTRIBUTING.md)를 참고하세요.
