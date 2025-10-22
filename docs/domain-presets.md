# Domain Presets (OPTIONS/SCORECARD/NEXT_ACTION)

Goal
- Standardize candidate shape, scoring, and execution order by domain.
- Improve selection quality and stabilize early steps without code changes.

Domain detection hints
- Mobile(iOS/Android): `*.xcodeproj`, `Package.swift`, `build.gradle(.kts)`, `pod`
- Web(front/back): `package.json`, `Dockerfile`, Next/Nest keywords, routes/controllers
- Data/LLM: `.env`, model providers, vector DB, pipelines, prompt configs
- Security sensitive: secrets/keys/oauth, authN/Z, privileges, migrations/deletions

Prompt preface (attach at top)
```
## DOMAIN_GUIDANCE: {mobile|web|data_llm|security}
- Follow this preset for OPTIONS (3–5), SCORECARD weights, and NEXT_ACTION order.
- Use the NEXT_ACTION DSL lines for steps that should auto-execute.
- Mark risky steps with [APPROVE]. Never print secrets.
```

Mobile
```
OPTIONS: architecture/build/test/CI-focused approaches (3–5).
SCORECARD: correctness 0.45, safety 0.25, relevance 0.20, novelty 0.10.
NEXT_ACTION:
run_cmd "xcodebuild -list" or "./gradlew tasks"
search_repo 'Package.swift|build.gradle|pod'
read_file ios/... or android/....:1-200
run_cmd "xcodebuild test" or "./gradlew test"
write_notes "modules/tests status; small patch next"
```

Web
```
OPTIONS: routing/controller/service/db-layer focused approaches (3–5).
SCORECARD: correctness 0.40, safety 0.20, relevance 0.25, novelty 0.15.
NEXT_ACTION:
find_files routes|controller|service|repository|Dockerfile|package.json
search_repo 'GET|POST|router|controller'
read_file src/routes/...:1-150
run_cmd "npm run lint && npm test -s"
write_notes "suspected area + test status"
```

Data/LLM
```
OPTIONS: prompt design/token budget/reranker/caching/observability (3–5).
SCORECARD: correctness 0.35, safety 0.25, relevance 0.25, novelty 0.15.
NEXT_ACTION:
find_files .env|config|provider|vector|pipeline
read_file config/**:1-120      # never print secrets
run_cmd "pytest -q -k inference|smoke"  # if applicable
write_notes "sample inference (no secrets), observability"
```

Security-sensitive
```
OPTIONS: key rotation/least privilege/audit logging/rollback plan.
SCORECARD: safety 0.40, correctness 0.30, relevance 0.20, novelty 0.10.
NEXT_ACTION:
write_notes "risk/impact, backup/rollback plan"
run_cmd "[APPROVE] git tag backup/<ts>"
edit_file path old => new                      # small scoped
run_cmd "[APPROVE] migration or rotation"
write_notes "audit log + verification"
```

Weight tuning heuristics
- Code/math: increase accuracy weight, reduce novelty.
- Creative: raise novelty weight, keep safety/relevance steady.
- Security tasks: safety first; enforce approvals and backups.

