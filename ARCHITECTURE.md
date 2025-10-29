# Snailer CLI - System Architecture

> **Note**: This document provides a high-level overview of Snailer's architecture without exposing core implementation details. For detailed implementation guides, see the `docs/` directory.

## Table of Contents

1. [Overview](#overview)
2. [System Architecture](#system-architecture)
3. [Module Diagram](#module-diagram)
4. [Data Flow](#data-flow)
5. [Component Interactions](#component-interactions)
6. [Technology Stack](#technology-stack)
7. [Deployment Architecture](#deployment-architecture)

---

## Overview

Snailer is an intelligent AI coding agent built with Rust, designed to help developers automate tasks directly from the terminal. The system uses a modular architecture that separates concerns between AI orchestration, tool execution, and context management.

### Key Architectural Principles

1. **Modularity**: Clear separation between agent runtime, tool execution, and context management
2. **Extensibility**: Easy to add new tools, models, and features
3. **Performance**: Rust-based for low latency and high reliability
4. **Multi-Model**: Unified interface supporting Claude, GPT, Grok, and Gemini
5. **Self-Learning**: Continuous improvement through ACE (Agentic Context Engineering)

---

## System Architecture

```
┌──────────────────────────────────────────────────────────────────────┐
│                         Presentation Layer                           │
│  ┌──────────────────────┐        ┌──────────────────────────────┐  │
│  │   CLI Interface      │        │   TUI (Terminal UI)          │  │
│  │   (clap-based)       │        │   (ratatui-based)            │  │
│  └──────────────────────┘        └──────────────────────────────┘  │
└───────────────────────────────┬──────────────────────────────────────┘
                                │
                                ▼
┌──────────────────────────────────────────────────────────────────────┐
│                         Application Layer                            │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                     Agent Runtime                            │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐  │   │
│  │  │  Execution   │  │   Context    │  │    Failover      │  │   │
│  │  │   Engine     │  │   Manager    │  │    Manager       │  │   │
│  │  └──────────────┘  └──────────────┘  └──────────────────┘  │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                     ACE System                               │   │
│  │  ┌──────────┐   ┌──────────┐   ┌──────────┐                │   │
│  │  │Generator │──▶│Reflector │──▶│ Curator  │                │   │
│  │  └──────────┘   └──────────┘   └──────────┘                │   │
│  └─────────────────────────────────────────────────────────────┘   │
└───────────────────────────────┬──────────────────────────────────────┘
                                │
                                ▼
┌──────────────────────────────────────────────────────────────────────┐
│                         Integration Layer                            │
│  ┌──────────────────┐  ┌──────────────────┐  ┌─────────────────┐  │
│  │   Tool Registry  │  │  AI API Client   │  │   Database      │  │
│  │   (File, Git,    │  │  (Multi-Model)   │  │   (SQLite)      │  │
│  │    Shell, etc.)  │  │                  │  │                 │  │
│  └──────────────────┘  └──────────────────┘  └─────────────────┘  │
└───────────────────────────────┬──────────────────────────────────────┘
                                │
                                ▼
┌──────────────────────────────────────────────────────────────────────┐
│                         Infrastructure Layer                         │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────────────┐    │
│  │ File System  │  │  AI Providers │  │  Analytics Service    │    │
│  │              │  │  (Claude, GPT,│  │  (Supabase/gRPC)      │    │
│  │              │  │   Grok, etc.) │  │                       │    │
│  └──────────────┘  └──────────────┘  └───────────────────────┘    │
└──────────────────────────────────────────────────────────────────────┘
```

---

## Module Diagram

### Core Modules

```
┌────────────────────────────────────────────────────────────────┐
│                        Agent Core                              │
│                                                                │
│  ┌──────────────────────────────────────────────────────┐    │
│  │              Agent Orchestrator                      │    │
│  │  - Task planning                                     │    │
│  │  - Execution coordination                            │    │
│  │  - State management                                  │    │
│  └──────────────┬───────────────────────────────────────┘    │
│                 │                                             │
│        ┌────────┼────────┐                                   │
│        ▼        ▼        ▼                                   │
│  ┌─────────┐ ┌─────────┐ ┌─────────────┐                   │
│  │  Tool   │ │   AI    │ │  Context    │                   │
│  │Registry │ │ Client  │ │  Manager    │                   │
│  └─────────┘ └─────────┘ └─────────────┘                   │
└────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────┐
│                      ACE Learning System                       │
│                                                                │
│  ┌───────────┐      ┌────────────┐      ┌──────────┐         │
│  │           │      │            │      │          │         │
│  │ Generator │─────▶│ Reflector  │─────▶│ Curator  │         │
│  │           │      │            │      │          │         │
│  └─────┬─────┘      └────────────┘      └────┬─────┘         │
│        │                                      │               │
│        │         ┌────────────────┐          │               │
│        └────────▶│ Context Store  │◀─────────┘               │
│                  │   (Bullets)    │                           │
│                  └────────────────┘                           │
└────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────┐
│                      Tool System                               │
│                                                                │
│  ┌──────────────────┐  ┌──────────────────┐                  │
│  │  Discovery Tools │  │ Modification     │                  │
│  │  - read_file     │  │ Tools            │                  │
│  │  - search_repo   │  │  - create_file   │                  │
│  │  - find_files    │  │  - edit_file     │                  │
│  │  - list_dir      │  │  - delete_file   │                  │
│  └──────────────────┘  └──────────────────┘                  │
│                                                                │
│  ┌──────────────────┐  ┌──────────────────┐                  │
│  │ Execution Tools  │  │  Platform Tools  │                  │
│  │  - run_cmd       │  │  - iOS build     │                  │
│  │  - shell_exec    │  │  - Android build │                  │
│  │  - git_*         │  │  - Web deploy    │                  │
│  └──────────────────┘  └──────────────────┘                  │
└────────────────────────────────────────────────────────────────┘
```

---

## Data Flow

### Task Execution Flow

```
┌─────────────┐
│ User Prompt │
└──────┬──────┘
       │
       ▼
┌──────────────────┐
│ Agent receives   │
│ and parses       │
│ request          │
└──────┬───────────┘
       │
       ▼
┌───────────────────────────┐
│ Context Manager           │
│ - Loads relevant bullets  │
│ - Selects top-K context   │
└──────┬────────────────────┘
       │
       ▼
┌────────────────────────────┐
│ AI API Call                │
│ - System prompt + context  │
│ - Tool definitions         │
│ - Conversation history     │
└──────┬─────────────────────┘
       │
       ▼
┌────────────────────────────┐
│ AI Response Parsing        │
│ - Text blocks              │
│ - Tool use blocks          │
└──────┬─────────────────────┘
       │
       ▼
┌────────────────────────────┐
│ Tool Execution             │
│ - Execute requested tools  │
│ - Collect results          │
└──────┬─────────────────────┘
       │
       ▼
┌────────────────────────────┐
│ Result Processing          │
│ - Format tool results      │
│ - Update conversation      │
└──────┬─────────────────────┘
       │
       ▼
       ┌─── Loop until completion
       │
       ▼
┌────────────────────────────┐
│ Final Response             │
│ - Display to user          │
│ - Record trace             │
└────────────────────────────┘
       │
       ▼
┌────────────────────────────┐
│ ACE Learning (periodic)    │
│ - Reflect on execution     │
│ - Extract lessons          │
│ - Update context           │
└────────────────────────────┘
```

### ACE Learning Cycle

```
┌──────────────────────────────────────────────────────────┐
│                    Task Execution                        │
│  Generator selects relevant bullets and executes task    │
│  Records all steps in ReasoningTrace                     │
└───────────────────────┬──────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────┐
│                  Reflection (Every 10 tasks)             │
│  Reflector analyzes ReasoningTrace                       │
│  Extracts lessons: what worked, what failed              │
│  Produces LessonDeltas                                   │
└───────────────────────┬──────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────┐
│                  Curation (Immediate)                    │
│  Curator integrates lessons into Context                 │
│  - Merges similar bullets                                │
│  - Links related knowledge                               │
│  - Adds new bullets                                      │
└───────────────────────┬──────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────┐
│                Refinement (Every 100 tasks)              │
│  Curator refines Context                                 │
│  - Updates utility scores                                │
│  - Prunes low-value bullets                              │
│  - Optimizes context size                                │
└───────────────────────┬──────────────────────────────────┘
                        │
                        ▼
                ┌───────────────┐
                │ Updated       │
                │ Context       │
                │ (Smarter!)    │
                └───────────────┘
```

---

## Component Interactions

### Agent Runtime Interactions

```
┌──────────────┐
│    Agent     │
│   Runtime    │
└──────┬───────┘
       │
       ├────────────┐
       │            │
       ▼            ▼
┌─────────────┐  ┌──────────────┐
│  Tool       │  │   AI API     │
│  Registry   │  │   Client     │
└──────┬──────┘  └──────┬───────┘
       │                │
       │                │
       ▼                ▼
┌──────────────────────────────┐
│      File System             │
│      - Read/Write files      │
│      - Execute commands      │
│      - Git operations        │
└──────────────────────────────┘

┌──────────────┐
│    Agent     │
│   Runtime    │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Context    │
│   Manager    │
└──────┬───────┘
       │
       ▼
┌──────────────┐       ┌──────────────┐
│  Context     │◀─────▶│   SQLite     │
│   Store      │       │   Database   │
└──────────────┘       └──────────────┘
```

### Multi-Model Support

```
┌──────────────────────┐
│   Agent Runtime      │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   AI API Client      │
│   (Unified Interface)│
└──────────┬───────────┘
           │
    ┌──────┼──────┬──────────┐
    │      │      │          │
    ▼      ▼      ▼          ▼
┌────────┐ ┌───────┐ ┌────────┐ ┌─────────┐
│Claude  │ │OpenAI │ │  xAI   │ │ Google  │
│  API   │ │  API  │ │  API   │ │  API    │
└────────┘ └───────┘ └────────┘ └─────────┘
```

### Failover Mechanism

```
┌──────────────────────────────────────────────────┐
│           Primary Model (Claude)                 │
└──────────┬───────────────────────────────────────┘
           │
           │ ┌─────────────┐
           ├─│ Health      │
           │ │ Monitor     │
           │ └─────────────┘
           │
    ┌──────┴──────┐
    │             │
    ▼             ▼
┌─────────┐   ┌────────────────────────────┐
│Success  │   │Overload/Error detected     │
│Response │   └──────────┬─────────────────┘
└─────────┘              │
                         ▼
              ┌────────────────────────────┐
              │Switch to Fallback (GPT)    │
              └──────────┬─────────────────┘
                         │
                         ▼
              ┌────────────────────────────┐
              │Continue serving requests   │
              └──────────┬─────────────────┘
                         │
                         │ ┌────────────────┐
                         ├─│Periodic health │
                         │ │check on primary│
                         │ └────────────────┘
                         │
                         ▼
              ┌────────────────────────────┐
              │Primary recovered?          │
              │Yes: Switch back            │
              │No: Stay on fallback        │
              └────────────────────────────┘
```

---

## Technology Stack

### Core Technologies

```
┌─────────────────────────────────────────────────────────┐
│                    Application                          │
│                                                         │
│  Language:     Rust (Edition 2021)                     │
│  Async Runtime: Tokio 1.x                              │
│  CLI Framework: clap 4.x                               │
│  TUI Framework: ratatui + crossterm                    │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                  Networking & APIs                      │
│                                                         │
│  HTTP Client:   reqwest 0.12                           │
│  gRPC:          tonic + prost                          │
│  WebSocket:     tokio-tungstenite                      │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                  Data & Storage                         │
│                                                         │
│  Serialization: serde + serde_json                      │
│  Local DB:      rusqlite (SQLite)                       │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                    Utilities                            │
│                                                         │
│  Regex:        regex 1.10                              │
│  UUID:         uuid 1.0                                │
│  DateTime:     chrono 0.4                              │
│  File Walking: walkdir 2.4                             │
│  Temp Files:   tempfile 3.8                            │
└─────────────────────────────────────────────────────────┘
```

### AI Provider Integration

| Provider | Models Supported | Features |
|----------|------------------|----------|
| **Anthropic** | Claude 4.5, 3.5-sonnet | Tool calling, streaming |
| **OpenAI** | GPT-5 | Function calling, JSON mode |
| **xAI** | Grok-code-fast-1, Grok-4 | Fast reasoning, code generation |
| **Google** | Gemini 2.5-pro | Multi-modal, function calling |

---

## Deployment Architecture

### Package Distribution

```
┌────────────────────────────────────────────────────────┐
│                  Source Repository                     │
│              (GitHub: felixaihub/snailer-cli)         │
└────────────────────┬───────────────────────────────────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
        ▼            ▼            ▼
┌─────────────┐ ┌─────────┐ ┌─────────────┐
│  Homebrew   │ │   npm   │ │   Binary    │
│  Formula    │ │ Package │ │  Releases   │
└─────────────┘ └─────────┘ └─────────────┘
        │            │            │
        ▼            ▼            ▼
┌─────────────────────────────────────────┐
│        User Installation                │
│  brew install snailer                   │
│  npm install -g @felixaihub/snailer    │
│  Direct binary download                 │
└─────────────────────────────────────────┘
```

### Runtime Architecture

```
┌──────────────────────────────────────────────────────┐
│              User's Machine                          │
│                                                      │
│  ┌────────────────────────────────────────────┐    │
│  │         Snailer CLI Process                │    │
│  │  ┌──────────────────────────────────────┐ │    │
│  │  │  Agent Runtime                       │ │    │
│  │  └──────────────────────────────────────┘ │    │
│  │  ┌──────────────────────────────────────┐ │    │
│  │  │  Local SQLite DB                     │ │    │        
│  │  └──────────────────────────────────────┘ │    │
│  └────────────┬───────────────────────────────┘    │
│               │                                      │
└───────────────┼──────────────────────────────────────┘
                │
    ┌───────────┼───────────┐
    │           │           │
    ▼           ▼           ▼
┌────────┐ ┌────────┐ ┌──────────────┐
│Claude  │ │OpenAI  │ │  Supabase    │
│  API   │ │  API   │ │  (Analytics) │
└────────┘ └────────┘ └──────────────┘
```

## Security & Privacy

### Data Flow Security

```
┌──────────────────────────────────────────────────────┐
│              User's Code & Data                      │
│         (Never leaves user's machine)                │
└────────────────────┬─────────────────────────────────┘
                     │
                     ▼
          ┌──────────────────────┐
          │   Local Processing   │
          │   - File reading     │
          │   - Context building │
          └──────────┬───────────┘
                     │
                     ▼
          ┌──────────────────────┐
          │  Minimal Data Sent   │
          │  to AI Providers:    │
          │  - Relevant snippets │
          │  - User queries      │
          │  - Context bullets   │
          └──────────┬───────────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
        ▼            ▼            ▼
   ┌─────────┐  ┌─────────┐  ┌─────────┐
   │ Claude  │  │ OpenAI  │  │  Other  │
   │   API   │  │   API   │  │   APIs  │
   └─────────┘  └─────────┘  └─────────┘

```

### Privacy Principles

1. **Local-First**: All code analysis happens on user's machine
2. **Minimal Data Transfer**: Only necessary context sent to AI providers
3. **No Code Storage**: AI providers don't store user code (per their policies)
4. **Opt-in Analytics**: Usage telemetry requires explicit user consent
5. **API Key Security**: Keys stored locally, never transmitted except to providers

---

## Extensibility Points

### Adding New Tools

```
1. Define tool schema in ToolRegistry
2. Implement tool execution logic
3. Add tool to system prompt
4. Test with various inputs
```

### Adding New AI Models

```
1. Add model configuration to config.rs
2. Implement API client method in api.rs
3. Add model to ModelSpec
4. Test with tool calling support
```

### Adding New ACE Features

```
1. Define new BulletType if needed
2. Implement reflection logic in Reflector
3. Add curation strategy in Curator
4. Update Context Store schema
```

---

## Performance Considerations

### Context Compression

- **LMLINGUA**: Budget allocation per document type
- **Selective Context Filter**: Surprisal-based token filtering
- **Result**: ~50% context size reduction

### Caching Strategy

- **Tool Results**: Cache frequent file reads
- **Bullet Selection**: LRU cache for top-K bullets
- **API Responses**: Optional response caching

### Async Operations

- **Parallel Tool Execution**: Independent tools run concurrently
- **Background Refinement**: ACE refinement runs in background
- **Streaming Responses**: Real-time output display

---

## Monitoring & Observability

### Metrics Tracked

```
Session Level:
- Session duration
- Total tasks completed
- Success/failure rate

Task Level:
- Task execution time
- Tool calls per task
- Iterations per task

Model Level:
- Token usage (input/output)
- API latency
- Error rate
- Cost estimation
```

### Logging

```
Levels:
- ERROR: Critical failures
- WARN:  Potential issues
- INFO:  Task progress
- DEBUG: Detailed execution
- TRACE: Full message logs
```

---

## Future Architecture Goals

### Planned Enhancements

1. **Plugin System**: Third-party tool plugins
2. **Multi-Agent Collaboration**: Multiple agents working together
3. **Advanced Caching**: Distributed cache support
4. **Real-time Collaboration**: Multiple users sharing context
5. **Custom Model Endpoints**: Self-hosted model support

---

## Research Foundations

Snailer's architecture incorporates concepts from state-of-the-art research:

### Core Systems

**ACE (Agentic Context Engineering)**
- Self-improving context management through reflection and curation
- Three-layer knowledge system (Active, Evolving, Archive)
- Continuous learning loop (Generator → Reflector → Curator)

**Context Compression**
- LMLINGUA: Budget-based allocation for efficient token usage
- Selective Context Filtering: Surprisal-based token filtering for relevant content preservation

**Multi-Model Orchestration**
- Transparent failover mechanism for production reliability
- Unified API interface across multiple AI providers
- Health monitoring and automatic recovery

### Implementation Notes

These systems are implemented with production-grade considerations:
- Latency budgets for real-time responsiveness
- Caching strategies for performance
- Async operations for concurrent execution
- Local-first privacy with minimal data transfer

---

## References

### Documentation

- [Agent Architecture Details](docs/AGENT_ARCHITECTURE.md)
- [ACE System Documentation](docs/ACE_SYSTEM.md)
- [Tool System Guide](docs/TOOL_SYSTEM.md)
- [Contributing Guide](docs/CONTRIBUTING.md)

### External Resources

- [Rust Programming Language](https://www.rust-lang.org/)
- [Tokio Async Runtime](https://tokio.rs/)
- [Anthropic Claude API](https://docs.anthropic.com/)
- [OpenAI API](https://platform.openai.com/docs/)

---

## License

MIT License - See [LICENSE](LICENSE) for details.
EULA - See [EULA.md](EULA.md) for end-user terms.
