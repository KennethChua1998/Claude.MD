---
name: organize
description: Translate a rough user prompt into an organized, executable task brief, confirm it with the user before touching anything, then execute with the built-in explore, plan, execute workflow (parallel subagents for reconnaissance, plan mode for design, goal-driven verification loops). Use when the user invokes /organize with a raw objective, or asks to organize or structure a request before executing it.
---

# Rough prompt to confirmed brief to execution

Nothing is explored, edited, or run before the brief is approved.

## 1. Translate

Rewrite the raw prompt (typos and shorthand interpreted generously) into a brief:

- **Objective**: one sentence, the corrected understanding of what the user wants.
- **Assumptions**: everything inferred rather than stated. Ambiguities become questions here, never silent picks.
- **Steps**: ordered, each with how it will be verified.
- **Success criteria**: verifiable end states, phrased so `/goal` could evaluate them from output.
- **Out of scope**: what will not be touched.

## 2. Confirm

Present the brief and wait for explicit approval (AskUserQuestion for real forks, plain confirmation otherwise). Corrections update the brief; a materially changed scope is re-confirmed. Only the approved brief is executed.

## 3. Execute with the built-in workflow

- **Explore**: spin up parallel Explore subagents for the reconnaissance each step needs; delegate searches, keep only conclusions.
- **Plan**: nontrivial work goes through plan mode, or `docs/plans/<feature>.md` per the spec-driven-dev skill.
- **Goal-driven execution**: implement step by step; after each step run its verification, fix, re-run until green or genuinely blocked. Report blockers instead of partial success. For long runs, suggest the user set `/goal <success criteria>` so the harness enforces completion across turns.
- **Subagents for scale**: independent workstreams run as parallel subagents; results are synthesized against the brief, not pasted raw.

## 4. Report against the brief

Each success criterion: pass or fail, with the proving output. Deviations from the approved brief and open items are stated explicitly.

Global rules hold throughout: no commit, push, or deploy without instruction; no scope creep beyond the confirmed brief.
