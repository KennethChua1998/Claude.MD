---
name: adversarial-review
description: Multi-lens adversarial review of a document or artifact (spec, plan, rules file like CLAUDE.md, config, architecture doc). Not for code diffs; use the built-in /code-review for those. Spawns independent skeptics with distinct lenses, verifies their findings, reports ranked by severity.
---

# Adversarial review (documents and artifacts)

For code diffs, use the built-in `/code-review` or `/security-review`. This skill is for prose artifacts: specs, plans, rule files, configs, architecture docs.

1. **Identify the artifact's job**: what must it make happen, and who consumes it (human, agent, tooling). Findings only count if they threaten that job.
2. **Spawn independent skeptics in parallel** (Agent tool, one lens each, 2 to 4 of them). Every prompt includes the artifact path(s), companion files it must stay consistent with, the consumer context, and the instruction: genuine skeptic, no padding, if something is fine say nothing.
   - **Contradictions**: statements that conflict with each other, with companion docs, or with how the consuming system actually behaves. Construct the concrete collision scenario.
   - **Misapplication**: literal readings that produce bad outcomes while technically complying; vague terms whose ambiguity changes outcomes; missing exceptions; over-zealous application.
   - **Practical backfire**: apply against the real usage mix (stacks, project types, scale); find rules written for one context that misfire in another, or whose cost exceeds their value.
   - **Omissions** (optional fourth lens): what the artifact's job requires that is absent.
3. **Verify every finding yourself** against the artifact before reporting. Discard theoretical ones unless the fix is nearly free. Require each survivor to have: exact quoted line, concrete failure scenario, severity.
4. **Report ranked by severity**, breakage before style. Propose the minimal fix per finding: a carve-out or reword, not a rewrite.
5. **Fix only on approval.**
