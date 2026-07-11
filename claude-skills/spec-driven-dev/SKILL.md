---
name: spec-driven-dev
description: House style for breaking requirements (client PDFs, feature ideas, product specs) into markdown docs and developing against them. Use when converting a requirements document or PDF into a SPEC or plan file, writing an implementation plan for a nontrivial feature, or executing work phase-by-phase from an existing spec.
---

# Spec-driven development - house style

Breakdowns are prose-and-table documents, not checkbox lists. Checkboxes (`- [ ]`) are allowed in exactly two places: external deliverable checklists and end-of-plan Testing/Acceptance sections.

## File conventions

| File | Purpose |
|---|---|
| `docs/SPEC.md` | Whole-product requirements, numbered sections |
| `docs/plans/<feature>.md` | Phased implementation plan for one feature (kebab-case) |
| `docs/ARCHITECTURE.md` | As-built state, written once the build stabilizes |
| source PDF/doc | Keep next to its breakdown in `docs/` - the breakdown cites it, never replaces it |

Larger projects group reference docs by area - `docs/backend/`, `docs/frontend/`, `docs/deployment/` - but plans always stay together under `docs/plans/`.

## Keeping the project CLAUDE.md wired

- Every breakdown doc created gets a row in the project CLAUDE.md's companion-docs table (`| Doc | What it holds |`) so future sessions discover it.
- Rows are pointers only - never duplicate spec or plan content into CLAUDE.md.
- When a plan is fully absorbed into `docs/ARCHITECTURE.md`, drop its row (and the plan file) - stale pointers are worse than none.

## Breaking down a requirements source

1. Read the entire source before writing anything (PDFs: read in page ranges).
2. Group requirements by module/tier/endpoint - never by sprint or ticket.
3. Write `docs/SPEC.md` as numbered `## 1.` … `## N.` sections:
   - `## 1. Project Overview`
   - one section per module/tier
   - `## N-1. Out of Scope`
   - `## N. Deliverables Checklist` - only if there is an external deliverable; this is a legitimate checkbox section
4. Tables are the default breakdown unit; add a "Why" column whenever the rationale isn't obvious from the row itself.
5. Anything ambiguous in the source goes into `## Open Questions` - never interpreted silently.

## Writing an implementation plan

Section order:

1. `## 1. Goal` - one paragraph.
2. `## 2. Options` - `### Option A / B / C`, each with Pros, Cons, Estimated effort.
3. `## 3. Recommended starting point` - pick one, say why.
4. Phases - `**Phase 0 - Foundation (no visible change yet)**` through `**Phase N**`, each ending with `*Checkpoint: [observable state, not "code written"]*`.
5. `## Suggested Implementation Order` - numbered, granular.
6. `## Open questions before implementation`
7. `## Out of scope` - explicit `Implement:` vs `Defer:` split when useful.
8. `## Testing Checklist` - grouped (Frontend / Backend / Regression).
9. `## Acceptance Criteria` - "The feature is complete when: …"

## Developing from the spec

- One phase at a time. Do not start phase N+1 until phase N's checkpoint has been observed running, not merely implemented.
- After each phase, update the plan's status using current-state buckets - `**Done**`, `**Not yet validated**`, `## Later / if time allows`, `## Known risks / gotchas`. Never a history log; changelogs belong in git.
- Experiments and investigations end with a `**Conclusion: [decision].**` line.
- Acceptance criteria gate completion - every criterion observed before the feature is called done.
- The plan is a living as-built document: when implementation diverges from it, update the plan to state what IS.
