# Snailer Architecture for Contributors

This guide complements the canonical `docs/ARCHITECTURE.md` overview and the end-user narrative in `docs/README_SNAILER.md`. It highlights the current module organization, execution paths, and contribution touchpoints so public contributors can extend Snailer with confidence while remaining aligned with existing documentation.

See the referenced docs for more diagrams, security/budget notes, and user stories; this guide links into them when pointing you toward deeper reading.

## At a glance

- **Language stack:** Rust (binary + library) built via Cargo; helper scripts and tests live under `scripts/`, `tests/`, and `swe_bench_*`.
- **Entry points:** `src/main.rs` (CLI + REPL) and `src/daemon.rs` (JSON-RPC server for editors like VS Code).
- **Modes handled:** single-prompt agent runs, interactive REPL, MDAP/GRPO rollouts, daemon-powered editors, and supporting history/KB artifacts.
- **Contribution focus:** agent runtime (`src/agent`), tool registry (`src/tools*`), KB/skills (`src/skills`, `src/user_skills`), verification (`src/build_*`, `src/sarif.rs`), docs (`docs/*`), and supporting services (`context/*`, `history.rs`, `analytics/`, etc.).
- **Companion docs:**
  - `docs/ARCHITECTURE.md` — official architecture diagram referenced earlier.
  - `docs/QUICKSTART.md`, `docs/RUN_NOW.md` — real usage flows.
  - `docs/SKILLS_*` + `docs/KNOWLEDGE_BASE_IMPLEMENTATION_PLAN_V3.md` — knowledge-base guidance.

## Repository structure (core areas)

```
snailer/
├── src/
│   ├── main.rs            # CLI entry, REPL loop, MDAP flags, signal/history helpers
│   ├── lib.rs             # Module re-exports used by binary + daemon
│   ├── agent/             # Planner, tool policy, failover, MDAP runtime, context integrations
│   ├── tools.rs           # Tool registry, duplicate guards, Bash session wiring
│   ├── tools/             # Approval UI, diff viewer, run_cmd contracts
│   ├── api.rs             # Multi-provider LLM client + tool-calling helpers
│   ├── config.rs          # Model specs, API key lookup, placeholder filtering
│   ├── ai_key_service.rs  # gRPC client for encrypted API keys
│   ├── crypto.rs          # AES-256 decryption + HMAC helpers
│   ├── context/           # Bullet representation, context store, retrieval helpers
│   ├── ace/               # ACE pipeline (Generator → Reflector → Curator)
│   ├── reasoning/         # Generator + reasoning trace types
│   ├── reflection/        # Lesson delta + reflector logic
│   ├── curation/          # Context curator + refinement policies
│   ├── history.rs         # Undo history, patch metadata, snapshots
│   ├── diff.rs            # Unified diff helpers used by history + tools
│   ├── build_pipeline.rs  # Project detection + stage DAG builder
│   ├── build_orchestrator.rs # Executes build stages, impact analysis, retries
│   ├── sarif.rs           # Normalized diagnostics + ToolResult serialization
│   ├── repair_guard.rs    # Repair-only mode enforcement
│   ├── bash_session.rs    # Non-PTY command runner + security policy
│   ├── analytics/         # Pricing, resolver, budget monitor, telemetry
│   ├── budget_manager.rs  # Runtime budget caps per plan
│   ├── pricing_table.rs   # Model pricing lookup table
│   ├── db.rs              # Supabase metrics for sessions/tasks/rollouts
│   ├── daemon.rs          # JSON-RPC server for editor integrations
│   ├── importers/         # Web capture + vision preprocessing (`@https://`)
│   ├── codewiki.rs        # Remote CodeWiki repo client
│   ├── auth.rs / user_auth.rs # Device login, account connection flows
│   ├── routing/           # Interaction heaviness classification
│   ├── skills/            # Knowledge base ingestion, vision helpers
│   ├── user_skills/       # Skill CLI + executor for reusable workflows
│   └── ui.rs              # UI guard for interactive terminal updates
├── docs/                  # Public docs (architecture, quickstart, commands, KB guides)
├── scripts/               # Benchmarks, demos, automation helpers
├── tests/ + swebench_*     # Test harnesses used in SWE benchmarking
├── proto/                 # Generated protobuf definitions referenced by gRPC
└── packages/, benches/, target/ – build/test artifacts and logs
```

Contributors typically touch `src/` and `docs/`, but feel free to inspect `scripts/` and `tests/` for runnable examples or validation flows.

## Module map (focus areas for contributors)

| Module / Dir | Role | Reference doc(s) | Contribution ideas |
|--------------|------|------------------|--------------------|
| `src/main.rs` | CLI entry, REPL loop, single-shot/interactive routing, signal/history handling | `docs/README_SNAILER.md`, `docs/ARCHITECTURE.md` | Add slash commands, improve UX logging, expand prompt preprocessing, tighten signal/save memguards |
| `src/agent/` | Execution core (planning, tool orchestration, MDAP runtime, smart router, failover, kb) | `docs/ARCHITECTURE.md`, `docs/MULTIMODAL_KB_AGENT_EXAMPLE.md` | Tune planner heuristics, extend tool policies, expose telemetry, improve MDAP or TF-GRPO logic |
| `src/tools.rs` + `src/tools/` | Tool registry (read/write/search/edit/run), approval UI, run_cmd contracts | `docs/COMMANDS.md`, `docs/CLI_LOGIN_GUIDE.md` | Add new tools, enhance validation/duplicate checks, support new command helpers |
| `context/` + `ace/` + `reasoning/` + `reflection/` + `curation/` | ACE memory pipeline (Generator → Reflector → Curator) and bullet store | `docs/CONTEXT_COMPRESSION_DESIGN.md`, `docs/KNOWLEDGE_BASE_IMPLEMENTATION_PLAN_V3.md` | Improve bullet scoring, add new reflection policies, document context tuning |
| `src/skills/`, `src/user_skills/` | KB ingestion + user skill ecosystem | `docs/SKILLS_USAGE_GUIDE.md`, `docs/MULTIMODAL_KB_GUIDE.md`, `docs/SKILLS_QUICKSTART.md` | Support new file/vision formats, add intent classifiers, document how to author skills |
| `src/build_pipeline.rs`, `src/build_orchestrator.rs`, `src/sarif.rs`, `src/repair_guard.rs` | Build/test pipeline + diagnostics | `docs/BUILD_PIPELINE_IMPLEMENTATION.md`, `docs/FAILOVER_SYSTEM_STATUS.md` | Add language support, improve impact analysis, refine SARIF parsing, tighten repair guard policy |
| `src/api.rs`, `src/config.rs`, `src/ai_key_service.rs`, `src/crypto.rs` | LLM providers, model specs, API key lookup/decryption | `docs/API_SPECIFICATION.md`, `docs/MDAP_SYSTEM_RESEARCH.md` | Add new providers, improve structured output handling, make key errors easier to debug |
| `src/analytics/`, `src/budget_manager.rs`, `src/pricing_table.rs`, `src/db.rs` | Pricing, usage, budget enforcement, metrics | `docs/PRICING.md`, `docs/PATCH_VALIDATION_IMPROVEMENTS.md` | Update pricing tables, simulate budget usage, add metrics/visualization helpers |
| `src/daemon.rs` | JSON-RPC server (editor integration) | `docs/DEVICE_FLOW_EXPLAINED.md`, `docs/CLI_AUTH_PATTERNS.md` | Add RPC methods (skill execution, long-running events), improve auth/error handling, emit richer events |
| `docs/` | Public guides/screenshots | `docs/ARCHITECTURE.md`, `docs/READMES*, docs/SKILLS_*` | Keep docs in sync, add diagrams, explain new modules or flows |

`lib.rs` re-exports primitives such as `Agent`, `Config`, `Tool`, `Context`, and `AcePipeline`, ensuring both binary and daemon share the same runtime foundation.

## Execution flows

The diagrams in `docs/ARCHITECTURE.md` describe the multi-layer architecture. Below are contributor-focused flow summaries referencing the actual code paths.

### 1. Single-shot CLI run

```
User prompt (--prompt) → `src/main.rs`
        ↓
`run_single_task`: load env (`load_environment`), history, MDAP reporter, and API key (env + backend)
        ↓
`Agent::new`: build ApiClient, ToolRegistry, context managers, ACE pipeline hook, kb integrations
        ↓
Agent loop: plan (`agent::planner`) → tool selection → API call (`api.rs`) → tool execution
        ↓
Tool execution (file edits via `tools.rs`, commands via `bash_session.rs`, approvals via `tools::approval_ui`)
        ↓
History (`history.rs`) + Metrics DB (`db.rs`) record results → tool results piped into agent
        ↓
CLI renders output + MDAP/GRPO reporter (via `agent::progress`)
```

Key contributions:

- Add new tools or validation layers in `ToolRegistry`.
- Harden API handling (timeouts, JSON parsing, structured outputs).
- Expand history or CodeWiki snapshot logic to capture more context.

### 2. Interactive REPL mode

```
Start `snailer` without `--prompt`
        ↓
`main.rs` renders interactive header + handles slash commands (`/path`, `/context`, `/clear`)
        ↓
Persistent agent + context reused across prompts (`persistent_agent`, `ContextStore`)
        ↓
Slash commands interact with agent or context + refresh UI (`ui.rs` guard, crossterm updates)
        ↓
Agent runs same tool loop as single-shot, but state carries over
```

Contribution ideas:

- Add new slash commands, session persistence features, or UI improvements.
- Persist ACE/KB stats across runs, expose additional metrics or insights in the UI.

### 3. Daemon/editor integration

```
Editor client connects to `src/daemon.rs`
        ↓
`initialize` with project path/model + optional auth token
        ↓
`run_agent` spawns same `Agent` but uses an `AgentReporter` to stream `AgentEvent`s
        ↓
Daemon forwards `agent.event` notifications + `tool.execute` payloads (for VS Code commands)
        ↓
Editor reacts by showing progress, tool logs, or triggering UI helpers
```

Contribution focus:

- Add new JSON-RPC methods (e.g., `execute_skill`), tighten auth checks, propagate richer event metadata.
- Surface tool outputs/errors in a structured way for editors.

## Supporting flows & systems

### Context & knowledge base

- `context::Context` stores bullets with Active/Evolving/Archive layers and relevance scoring.
- `ace::AcePipeline` orchestrates Generator → Reflector → Curator to evolve the context (`docs/CONTEXT_COMPRESSION_DESIGN.md`).
- `skills/` ingestion handles text, PDF, and vision extraction, feeding the KB; user-defined skills live under `user_skills/`.

Contribution opportunities:

- Introduce new context heuristics or pruning strategies.
- Extend KB ingestion (new file formats, better OCR fallbacks).
- Document ACE tuning or new reflection policies in `docs/*`.

### Build/test verification

- `build_pipeline.rs` detects project type and builds `BuildStage` DAGs.
- `build_orchestrator.rs` executes impacted stages, handles retries, injects SARIF diagnostics.
- `sarif.rs` normalizes diagnostics and creates `ToolResult`s; `repair_guard.rs` restricts edits when regressions occur.

Potential contributions:

- Support more languages/frameworks.
- Improve diagnostics parsing (better file/line info, clearer grammar).
- Refine repair guard messages or automate repair strategy.

### API keys + backend plumbing

- `ai_key_service.rs` talks to the backend gRPC service (`SNAILER_GRPC_ADDR`) to retrieve encrypted keys.
- `crypto.rs` decrypts using AES-256-CBC + HMAC.
- `account_config.rs` mirrors `~/.snailer/config`.

Public contributor ideas:

- Document how to mock gRPC/crypto for local development.
- Add CLI helpers or scripts to bootstrap account tokens and configs.
- Improve error messaging when keys fail to decrypt.

### Analytics & budget enforcement

- `analytics::pricing`, `pricing_table.rs`, and `budget_manager.rs` estimate token costs.
- `analytics::budget_monitor` and `db.rs` log metrics, rollouts, and session/task status.

Ideas:

- Add regression tests for cost estimation.
- Build visualization scripts that analyze `db.rs` data (see `docs/BUILD_PIPELINE_IMPLEMENTATION.md` for reporting style).

## Diagrams (textual)

The ASCII diagrams below mirror `docs/ARCHITECTURE.md` with contributor-focused annotations.

### High-level data flow

```
                    +----------------+
                    |   CLI / Daemon |
                    | parse args,    |
                    | handle REPL    |
                    +-------+--------+
                            |
                            v
                 +----------+-----------+
                 |       Agent          |
                 | planning + tool loop |
                 +----------+-----------+
                            |
          +-----------------+-----------------+
          |                 |                 |
          v                 v                 v
     +---------+       +----------+       +------------+
     | API.rs  | <---> | Context  | <---> | Tools.rs   |
     | LLM API |       | + ACE    |       | run_cmd,    |
     +---------+       +----------+       | read/write, |
                                          | approval UI |
                                          +------------+
```

### Tool invocation flow

```
Agent decides on tool
        ↓
ToolRegistry validates (no duplicate edits, allowed path patterns)
        ↓
`bash_session.rs` runs commands (logged under `.snailer/bash_logs`)
        ↓
Tool result returned → `history.rs` records patch → agent continues loop
```

### Build verification path

```
Diff + impacted files
        ↓
`build_pipeline.rs` → impacted stages
        ↓
`build_orchestrator.rs` executes groups + retries
        ↓
`sarif.rs` produces diagnostics → ToolResult → `repair_guard.rs`
```

## Next steps for contributors

1. **Read `docs/ARCHITECTURE.md`, `docs/README_SNAILER.md`, and the relevant quickstarts** to get a big-picture sense of flows and tooling expectations.
2. **Run `cargo test`, `scripts/run_comprehensive_tests.sh`, or `swe_bench_tests.sh`** when modifying runtime logic.
3. **Inspect `src/agent`, `src/tools.rs`, and the KB docs (`docs/SKILLS_*`)** before adding features to those areas.
4. **Document what you discover**: update this guide, add a diagram to `docs/ARCHITECTURE.md`, or expand the quickstart for your changes.

Focused contributions include adding new tools, extending KB ingestion, expanding verification pipelines, and keeping `docs/` aligned with code. When unsure, reference the linked docs or ask maintainers before submitting a PR.
---

## Repository structure (core areas)

```
snailer/
├── src/
│   ├── main.rs            # CLI entry point & REPL/daemon glue
│   ├── lib.rs             # Library root that wires modules together
│   ├── agent/             # Core agent runtime (planning, tool orchestration)
│   ├── tools.rs           # Tool registry, helper utilities
│   ├── tools/             # Tool UI widgets (approval, diff viewer, run_cmd contracts)
│   ├── api.rs             # Multi-provider API client (Claude, OpenAI, Gemini, etc.)
│   ├── config.rs          # API key lookup + model metadata
│   ├── context/           # Context bullets + stores (ACE memory)
│   ├── ace/               # Generator → Reflector → Curator pipeline
│   ├── reasoning/         # Traceable reasoning + feedback hooks
│   ├── reflection/        # Lesson deltas & post-execution reflection
│   ├── curation/          # Context curation (merge/summarize/prune)
│   ├── skills/            # Knowledge base ingestion, matching, and vision helpers
│   ├── user_skills/       # Skill CLI/executor for reusable user workflows
│   ├── history/           # Undo history, patch metadata, diff helpers
│   ├── build_pipeline.rs  # Detect project type + stage DAG
│   ├── build_orchestrator.rs # Runs verification stages + SARIF diagnostics
│   ├── sarif.rs           # Normalized diagnostics for build/test failures
│   ├── bash_session.rs    # Non-PTY bash execution + security guard
│   ├── analytics/         # Pricing, usage reporting, budget monitor
│   ├── db.rs              # Supabase metrics storage (sessions/tasks/rollouts)
│   ├── daemon.rs          # JSON-RPC daemon used by VS Code and similar clients
│   ├── importers/         # Web capture + vision preprocessing (`@` links)
│   ├── codewiki.rs        # Snapshot client for Code Wiki service
│   └── helpers...         # auth.rs, history.rs, ui.rs, etc.
├── docs/                  # Public-facing guides (quicks starts, architecture, etc.)
├── tests/ + swe_bench_*    # Test harnesses useful for local verification
├── scripts/               # Helper scripts (benchmarks, demos, automation)
└── packages/ + proto/      # Supporting build artifacts/tools
```

Most public-facing contributions live under `src/` and `docs/`, but feel free to explore supporting directories like `swe_bench_*` for testing patterns.

---

## Module map (focus areas for contributors)

| Module/Dir | Role | Contribution ideas |
|------------|------|--------------------|
| `src/main.rs` | CLI entrypoint + REPL/daemon routing | Add new CLI flags, improve interactive commands, strengthen signal handling feedback |
| `src/agent/` | Agent runtime (planning, tool evaluation, budgets, context) | Tune planner heuristics, extend tool policies, improve telemetry, add new guard logic |
| `src/tools.rs` + `src/tools/` | Tool registry + UI helpers | Add new tools, enhance approval UI, improve file-edit validation, tighten run_cmd policy |
| `src/context/` + `ace/` + `curation/` | Long-term memory, ACE pipeline | Improve bullet scoring, add new context stores, add reflection/refinement hooks |
| `src/skills/` & `src/user_skills/` | Knowledge base + reusable skills | Extend KB ingestion formats, add intent classifiers, document how to write new skills |
| `src/build_pipeline.rs` + `build_orchestrator.rs` | Build/test DAG and orchestrator | Add support for new languages, improve impact analysis, better diagnostic parsing |
| `src/api.rs` + `config.rs` | Model/provider handling | Add new models, standardize payloads, add structured-response helpers |
| `src/analytics/`, `budget_manager.rs` | Pricing + plan enforcement | Update pricing, improve budget heuristics, add metrics |
| `src/daemon.rs` | WebSocket JSON-RPC surface | Support new editor events, extend daemon-side tooling, improve auth flow |
| `docs/` | Guides and design docs | Keep `docs/` aligned with code changes, maintain quickstarts, add new architecture diagrams |

Each area references the library through `lib.rs` re-exports so that `Agent`, `Config`, `Context`, `AcePipeline`, `Tool`, etc. are available to the binary and daemon alike.

---

## Execution flows

### 1. CLI → Agent → Tools (Single-shot)

```
user prompt (--prompt)
        ↓
    CLI (`main.rs`)
        ↓
    Agent::new → ApiClient + ToolRegistry
        ↓
  Agent loop: plan → tool call → LLM → tool result
        ↓
 Tools handle file edits, command execution, diffs
        ↓
 HistoryRecorder logs patches + MetricsDb records usage
        ↓
 Output rendered to terminal
```

Key contributions along this path include:

- Making tool calls more deterministic (`agent::planner`, `ToolRegistry`)
- Improving API robustness (timeouts, JSON parsing in `api.rs`)
- Expanding tool coverage (new read/write helpers, custom verification tools)
- Enhancing history recording and undo support (`history.rs`, `diff.rs`)

### 2. Interactive REPL mode

```
Start `snailer` without --prompt
        ↓
Interactive header + slash commands (`main.rs` handles `/path`, `/context`, `/clear`)
        ↓
Persistent Agent/Context reused across prompts
        ↓
Commands call the same agent runtime + tools
        ↓
CLI updates status lines using crossterm (UI guard in `ui.rs`)
```

Interactive additions include new slash commands, UI improvements, and session persistence (history + context saves).

### 3. Daemon + editor integration

```
WebSocket client (VS Code) 
        ↓
`daemon.rs` (auth token → initialize → run_agent)
        ↓
Same `Agent`/tools path as CLI but reporter sends `AgentEvent`s
        ↓
Daemon streams `agent.event` notifications + `tool.execute` requests
        ↓
Client renders progress, handles tool operations
```

Daemon contributions focus on bringing events and tool requests to external UIs, improving JSON-RPC error handling, and expanding supported methods.

---

## Supporting flows & systems

### Context + knowledge updates

- `Context` stores bullets with layered metadata (Active/Evolving/Archive) and exposes retrieval helpers.
- `AcePipeline` runs Generator → Reflector → Curator to learn new bullets from reasoning traces (`reasoning::Generator`, `reflection::Reflector`, `curation::Curator`).
- `skills/` ingestion handles text, PDF, and vision extraction feeding the KB (used via `kb::KnowledgeBase` re-export).

Contribution ideas:

- Document how to add new context heuristics or reflection policies.
- Add more vision extraction fallbacks or KB matchers.
- Improve bullet pruning strategies and serialization.

### Build/Test verification

- `build_pipeline.rs` detects project type and builds a DAG of stages (`BuildStage`).
- `build_orchestrator.rs` executes relevant stages with impact analysis, retries, and SARIF parsing.
- `sarif.rs` normalizes diagnostics and can produce tool results for the agent.
- `repair_guard.rs` limits edits when regression protection is needed.

Contributions: Support additional toolchains, improve error parsing, add new verification policies, tighten repair guard messages for contributors.

### API key & backend plumbing

- `ai_key_service.rs` talks to the backend gRPC service to load encrypted API keys.
- `crypto.rs` decrypts them with AES-256‑CBC.
- `account_config.rs` manages the local `~/.snailer/config`.

Public contributions can:

- Document how to mock or stub these services.
- Add CLI helpers for easier token setup.
- Improve error messaging when keys are missing.

### Analytics & budget controls

- `analytics::pricing`, `pricing_table.rs`, `budget_manager.rs`, and `analytics::budget_monitor` estimate model costs and enforce plan limits.
- `db.rs` records sessions/tasks/rollouts for future analysis.

Ideas: add tests for pricing estimates, simulate usage data, or write scripts that visualize budget vs usage for contributors.

---

## Diagrams (textual)

### High-level data flow

```
                    +----------------+
                    |   CLI/Daemon   |
                    | parse args,    |
                    | handle REPL    |
                    +-------+--------+
                            |
                            v
                 +----------+-----------+
                 |       Agent          |
                 | planning + tool loop |
                 +----------+-----------+
                            |
          +-----------------+-----------------+
          |                 |                 |
          v                 v                 v
     +---------+       +----------+       +----------+
     | API.rs  | <---> | Context  | <---> | Tools.rs |
     | LLM API |       | + ACE    |       | run_cmd, |
     +---------+       +----------+       | read/write|
                                          +----------+
```

### Tool invocation flow

```
Agent decides on tool
        ↓
ToolRegistry validates (duplicate guards, path checks)
        ↓
BashSession (if run_cmd) executes + logs under `.snailer/bash_logs`
        ↓
Tool result returned → history recorded → agent loop continues
```

### Build verification path

```
Diff + impacted files
        ↓
BuildPipeline → impacted stages
        ↓
BuildOrchestrator executes (parallel groups, retries)
        ↓
Sarif diagnostics → ToolResult injected → RepairGuard updates
```

---

## Next steps for contributors

1. **Read `docs/README_SNAILER.md` + `docs/QUICKSTART.md`** to understand usage flows.
2. **Run `cargo test` and `scripts/run_comprehensive_tests.sh`** (optional but helpful) to gain confidence before proposing changes.
3. **Explore `src/agent`, `src/tools.rs`, and `docs/ARCHITECTURE.md`** for deeper context before coding.
4. **Document your findings**: add diagrams, update this architecture guide, or explain new modules you add.

Open-source-friendly contributions include adding new tools, improving KB ingestion, verifying builds for new languages, and polishing docs. Use existing modules as reference points and feel free to ask maintainers for direction if needed.
