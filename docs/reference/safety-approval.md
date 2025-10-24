# Safety and Approval Policy

Purpose
- Prevent destructive or sensitive operations from auto-executing.
- Ensure auditability and fast rollback.

Secrets
- Never print secrets or token values. For `.env`/keys/tokens: report presence/path only.
- Scrub outputs that might contain credentials before logging.

Run Command Whitelist (examples)
- Git/meta: `git status`, `git diff --name-only`, `git log -n 1`
- JS/TS: `npm ci`, `npm run build`, `npm test -s`, `pnpm`/`yarn` equivalents
- Python: `pytest -q`, `ruff check .`, `flake8`, `mypy --strict --no-color-output`
- Go: `go build ./...`, `go test ./...`
- Java/Kotlin: `./gradlew test`, `./gradlew build`
- Rust: `cargo build`, `cargo test`
- iOS/Android: `xcodebuild -list`, `./gradlew :app:test`
- Lint/format: `eslint .`, `prettier -c .`, `black --check .`

Approval Required (risky)
- Destructive: `rm -rf`, `chmod -R`, `chown -R`, filesystem mutations outside workspace
- Network/deploy/DB: any operation that pushes, migrates, or modifies live data
- Privileged or irreversible steps
- Mark with `[APPROVE]` inside `run_cmd` and require human reviewer confirmation

File Edits
- Use `edit_file` for small, localized patches only; capture before/after `diff -u`.
- For large additions, propose a separate create step (not inlined edits).

Backups and Rollback
- For risky tasks, create a backup tag/snapshot first (e.g., `git tag backup/<ts>`).
- Document rollback steps in `write_notes` before executing changes.

Auditing
- Every auto-executed step writes a brief `write_notes` entry: what/why/result.
- Keep an index of tasks and approvals to compute success/retry metrics.

