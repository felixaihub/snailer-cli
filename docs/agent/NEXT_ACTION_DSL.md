# NEXT_ACTION DSL (Hybrid Execution)

Purpose
- Run simple, deterministic steps immediately and consistently.
- Keep ambiguous reasoning with the LLM while reducing loops.

Principles
- Lines that match the DSL are auto-executed (whitelist policy).
- Non-matching lines are treated as instructions for the LLM.
- Dangerous actions require explicit approval with `[APPROVE]`.
- Always log outcomes with `write_notes` for reproducibility.

Syntax (one per line)
```
search_repo 'query'
find_files pattern
read_file path[:start-end]
run_cmd "command"
edit_file path old => new      # small patch only, keep diff
write_notes "summary or findings"
```

Rules
- Auto-execute only if the line matches the exact forms above.
- Never print secrets. For `.env`/keys/tokens: report presence/path only.
- Limit `edit_file` to localized changes; record before/after diff.
- Use `[APPROVE]` inside `run_cmd` for risky/irreversible steps.

Examples
```
search_repo 'router|controller'
find_files package.json|Dockerfile
read_file src/routes/users.ts:1-150
run_cmd "npm run lint && npm test -s"
edit_file src/app.ts import Foo => import Foo, Bar
write_notes "Lint/test healthy; next: patch controller guard"
```

Cheat Sheet (local mapping)
- `search_repo 'foo'` → `rg -n -S 'foo' --hidden --glob '!.git'`
- `find_files pattern` → `rg --files | rg -n 'pattern'` (or `fd 'pattern'`)
- `read_file a/b.ts:10-80` → `sed -n '10,80p' a/b.ts`
- `run_cmd "…"` → execute only if whitelisted (see Safety/Approval)
- `edit_file` → apply small patch; capture `diff -u` before/after
- `write_notes` → append concise result/hypothesis/next move

Rollout (suggested)
- Week 1: enable `search_repo`/`find_files`/`read_file` only.
- Week 2: add `run_cmd` for build/test/lint.
- Week 3: pilot `edit_file` (small patches), risky steps require approval.

Metrics
- NEXT_ACTION success rate, retries, time-to-first-execution (TTFX), total latency,
  tool call distribution, SELECT consistency/reproducibility.

