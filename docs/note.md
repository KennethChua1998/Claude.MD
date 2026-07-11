# Standing decisions

Why this repo is set up the way it is. Update when a decision changes.

## 1. Don't rebuild what Claude Code already has

Claude Code ships with the explore, plan, execute workflow, plus subagents and skills as native features. Custom skills and CLAUDE.md rules must not restate these.

| Stage | Built-in |
|---|---|
| Explore | Explore subagent (read-only fan-out search), general-purpose agents |
| Plan | Plan mode (`/plan`), Plan agent, `opusplan` model setting |
| Execute | Main loop; `/goal <condition>` loops turns until a verifiable end state holds |
| Verify | `/verify`, `/code-review`, `/security-review`, `/simplify` |
| Subagents | Agent tool; custom agents via `.claude/agents/<name>.md` (per-agent `model:` frontmatter) |
| Skills | Skill system; user skills in `~/.claude/skills/`, project skills in `<repo>/.claude/skills/` |

Before writing a new skill or workflow rule, check the built-ins first (the claude-code-guide agent can confirm what exists). A custom skill earns its place only when it carries something Claude cannot know on its own:

- house conventions (example: `spec-driven-dev`)
- domain procedures (example: `firestore-indexes`)

A skill that restates a built-in workflow shadows it at best and duplicates it at worst.

## 2. CLAUDE.md is memory, not a manual

The built-in system prompt already tells Claude how to work, and it is tested by Anthropic's engineers and researchers. So the global CLAUDE.md only records:

- preferences: style, formatting, thresholds
- house facts: stacks, conventions, workflows
- deltas: the few places where we want different-from-default behavior

Keep it short (around 100 lines). If a line only repeats what Claude already does by default, delete it.
