# Hybrid Runbook (Human + Agent)

Objective
- Combine deterministic tool steps (auto) with LLM planning (ambiguous) for speed and stability.

Operating Steps
1) Pick domain preset → paste preset and DSL block at prompt top.
2) Agent returns SELECT/NEXT_ACTION → highlight only DSL-matching lines.
3) Execute whitelist DSL lines immediately; feed raw results back to the model.
4) Treat non-DSL or ambiguous lines as planning guidance → ask model to refine.
5) Steps tagged `[APPROVE]` require reviewer confirmation before execution.
6) Log each step with `write_notes` (result, hypothesis, next move).

Rollout
- Phase 1: `search_repo`/`find_files`/`read_file` only.
- Phase 2: add `run_cmd` (build/test/lint).
- Phase 3: enable small `edit_file`; risky steps require `[APPROVE]`.

Monitoring Template
```
TaskID | Domain | DSL% | APPROVE# | Success/Total | TTFX(s) | Total(s) | Retries | Failure Type
```

Review Cadence
- Weekly: analyze failures → update whitelist, presets, and prompt snippets.

References
- NEXT_ACTION DSL: docs/agent/NEXT_ACTION_DSL.md
- Domain Presets: docs/agent/domain-presets.md
- Safety & Approval: docs/agent/safety-approval.md

