# Snailer Documentation

> 🎯 **Welcome!** This is the comprehensive documentation for Snailer's core agent architecture and systems.

## 📖 Documentation Index

### Getting Started

- **[기여 가이드 (CONTRIBUTING.md)](./CONTRIBUTING.md)**
  - 개발 환경 설정
  - 기여 프로세스
  - 코딩 가이드라인
  - Pull Request 제출 방법

### Core Architecture

- **[에이전트 아키텍처 (AGENT_ARCHITECTURE.md)](./AGENT_ARCHITECTURE.md)**
  - Agent 구조 및 실행 모드
  - 도구 실행 루프
  - 컨텍스트 관리
  - VS (Verification/Selection) 블록
  - 데이터베이스 추적

- **[도구 시스템 (TOOL_SYSTEM.md)](./TOOL_SYSTEM.md)**
  - 내장 도구 목록
  - 도구 실행 흐름
  - 새로운 도구 추가하기
  - 보안 및 성능 고려사항

- **[ACE 시스템 (ACE_SYSTEM.md)](./ACE_SYSTEM.md)**
  - Agentic Context Engineering 개요
  - Bullet 기반 지식 관리
  - Generator → Reflector → Curator 사이클
  - 자기 학습 메커니즘

### Additional Resources

- **[Documentation Status](./DOCUMENTATION_STATUS.md)**
  - Implementation status of all documented features
  - What's implemented vs. planned vs. reference-only

- **[Reference Documentation](./reference/)**
  - NEXT_ACTION_DSL.md - DSL syntax reference
  - runbook.md - Operational procedures
  - safety-approval.md - Safety guidelines

- **[Experimental Features](./experimental/)**
  - VS_PROMPTS.md - Verification/Selection prompt concepts
  - Features under development or research

---

## 🚀 Quick Navigation

### For New Contributors

1. **Start Here**: [기여 가이드](./CONTRIBUTING.md)
2. **Learn the Structure**: [에이전트 아키텍처](./AGENT_ARCHITECTURE.md)
3. **Pick an Area**:
   - 🔧 Want to add tools? → [도구 시스템](./TOOL_SYSTEM.md)
   - 🧠 Interested in AI context? → [ACE 시스템](./ACE_SYSTEM.md)

### For Researchers

1. [ACE 시스템](./ACE_SYSTEM.md) - Self-improving context management
2. [에이전트 아키텍처](./AGENT_ARCHITECTURE.md) - Agent design patterns
3. Research paper: [Agentic Context Engineering](https://arxiv.org/abs/2510.04618)

### For Developers

1. [도구 시스템](./TOOL_SYSTEM.md) - Extend agent capabilities
2. [에이전트 아키텍처](./AGENT_ARCHITECTURE.md) - Understand execution flow
3. [기여 가이드](./CONTRIBUTING.md) - Development workflow

---

## 📚 Document Overview

### Core Documentation (Fully Implemented)

| Document | Purpose | Audience | Status |
|----------|---------|----------|--------|
| [CONTRIBUTING.md](./CONTRIBUTING.md) | How to contribute to Snailer | All contributors | ✅ Active |
| [AGENT_ARCHITECTURE.md](./AGENT_ARCHITECTURE.md) | Core agent design and structure | Developers, Researchers | ✅ Active |
| [TOOL_SYSTEM.md](./TOOL_SYSTEM.md) | Tool execution and extension | Developers | ✅ Active |
| [ACE_SYSTEM.md](./ACE_SYSTEM.md) | Self-learning context system | Researchers, Advanced devs | ✅ Active |

---

## 🔗 Related Documentation

For the private repository documentation (internal use), see:
- `../../docs/` - Original documentation in the private repo
- Private repo contains implementation details not exposed in public docs

---

## 🎯 Design Philosophy

Snailer's documentation is designed to be:

1. **🌐 Public-Friendly**: Core concepts without implementation secrets
2. **📖 Educational**: Learn agent design patterns
3. **🤝 Contribution-Focused**: Easy for newcomers to contribute
4. **🧠 Research-Oriented**: Based on academic research (ACE paper)

---

## 💡 What's NOT in Public Docs

The following are kept in the private repository:
- Production API endpoints and credentials
- Proprietary optimization algorithms
- Internal deployment configurations
- Customer-specific integrations

---

## 🤝 Community

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: Questions and ideas
- **Discord**: https://discord.gg/snailer
- **Twitter**: @snailer_ai

---

## 📝 License

All documentation is under MIT License.

---

**Happy Learning! 🎉**

If you have questions, feel free to open a Discussion or join our Discord!
