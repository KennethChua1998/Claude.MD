# Global Instructions

These apply to every project unless the project's own `CLAUDE.md` overrides them.

Keep this file lean (budget: about 100 lines). If a rule here or in a project CLAUDE.md looks stale (tech no longer used, superseded by a skill, contradicted by current practice), say so and propose removing it instead of silently following it.

## Commit Message Convention

Follow [Conventional Commits](https://www.conventionalcommits.org/): `<type>(<scope>): <subject>`.

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.

**Rules:**

- Subject in imperative mood ("add", not "added"), lowercase, no trailing period, under 72 chars.
- Scope is optional; use the area of the codebase (e.g. `auth`, `api`, `ui`).
- Body (optional, after a blank line) explains **why**, not what. Wrap at 72 chars.
- Footer: `Fixes #123` auto-closes the issue. `BREAKING CHANGE:` marks breaking changes.

**Good:**

```
feat(auth): add SSO login via Google
fix(api): retry token refresh on 401 instead of redirecting
build(deps): bump axios from 1.11.0 to 1.15.0
```

**Bad:** `update`, `.`, `Chages and additions made.`, `Added stuff.`

## Security - Never Trust the Client

All validation, authorization, and business-rule enforcement lives server-side; clients (browsers, mobile apps, devices) are bypassed trivially with curl or dev tools. Client-side checks are UX polish only, added only when the identical rule already exists on the backend. Web-stack specifics live in the web projects' own CLAUDE.md files.

## Comments & Docstrings - Be Terse

Default to no comments and no docstrings; add one only for a genuinely non-obvious WHY (a subtle invariant, a workaround for a specific bug).

- Never restate what the code already shows: no behavior narration ("Compute RSI" on `compute_rsi`), no caller lists, no Args/Returns for type-hinted signatures, no module headers about I/O or import policy, no explanations of one-liners.
- A module header, when earned, is one line (e.g. `"""Pure shared math - identical in backtest and scanner."""`).

## Writing Style

- No emoji in code, comments, logs, commit messages, or docs.
- No em dashes in own prose, files or replies; use a comma, colon, parentheses, or a plain hyphen. User-authored content and data pass through untouched.
- Docs describe what IS, not history: no "previously" or "was changed from X to Y". Changelogs belong in git; a repo's deliberate CHANGELOG.md is exempt.

## Code Quality

- **Forward-only changes**: rename cleanly and update every call site. No shims, no `_old` aliases, no fallbacks to old names. Data migration belongs in the migration layer, not app code.
  - Exception: only when the other side of a contract is out of reach (published mobile app, firmware in the field, third parties on a public API or webhooks). Keep the existing contract working, add the change as a new version alongside it, and remove the old version once nothing uses it.
  - When both sides are in hand (e.g. the backend and frontend repos are both available), update both cleanly: no fallback, no versioning.
- **DRY**: wrote the same code twice? Extract a helper. Skip only when the two copies merely look alike and will grow apart. Business logic (pricing, P&L, validation rules) is never copy-pasted.
- **No magic values** in app code: repeated numbers and strings become named constants; fixed value sets become frozen enums. Exempt: hardware registers and pin maps in firmware, tuning numbers in throwaway research code.
- **Reuse first**: before writing new code, check the repo's existing helpers and patterns, and extend those.

## Workflow Discipline

- Never commit or push without explicit instruction.
- No scope creep - never add features or refactor beyond what was asked.
- If a request is ambiguous, state the interpretations and ask before proceeding; never pick one silently.
- Don't create files the task doesn't need; new files the task genuinely calls for (a module, a test file, a spec doc) are fine.
- No prose recaps after code changes; verification output (test/lint results) is required reporting, not a recap.

## Verification

- Fixing a bug? First write a test that reproduces it, then make that test pass. If no test can reproduce it (needs real hardware or a live environment), state how the fix was checked instead.
- New logic gets a test for exactly what changed (this input gives this output), if the repo already has a test suite. If it has none, flag the gap; don't build a test framework for a small change.
- Done means: the relevant tests and lint ran, and the output is shown. A red run is not done.
- Changes touching logic, data, or auth get one extra pass before done: try to break the change with edge cases, bad inputs, empty data, and repeated calls.
- Pure copy or styling tweaks skip all of the above.

## Secrets

Secrets live in a secret manager - never hardcoded, never in a committed `.env`, never in Terraform config (values written there end up in `terraform.tfstate`).

## Firestore

The composite-index workflow lives in the `firestore-indexes` skill - invoke it whenever touching `.where().orderBy()` queries or `firestore.indexes.json`.
