# Global Claude Code Config Repository

A working global [Claude Code](https://claude.com/claude-code) setup you can copy: a global `CLAUDE.md` instruction file plus six reusable skills, tracked with git and symlinked into `~/.claude/` so every device stays in sync. Take the whole setup or just one skill. No secrets inside.

**What is CLAUDE.md?** The instruction file Claude Code reads at the start of every session. The global copy at `~/.claude/CLAUDE.md` applies to every project on the machine.

**What is a skill?** A markdown file of instructions that Claude Code loads on demand when a task matches its description. Global skills live in `~/.claude/skills/` and work in every project.

**How it works:** the live files under `~/.claude/` are symlinks into this repo. Edit them anywhere (you or Claude), then `git diff` here to review, commit, and push. Pull on another device and run setup to get the same config there.

## What's inside

| Repo path | Live path (symlink) |
|---|---|
| `global-CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `claude-skills/<name>/` | `~/.claude/skills/<name>/` |

Every skill is standalone: copy its folder into `~/.claude/skills/` and it works.

| Skill | What it does |
|---|---|
| `adversarial-review` | Reviews a doc (spec, plan, CLAUDE.md, config) with independent skeptics and reports verified findings by severity |
| `file-grouper` | Reorganizes files and folders into logical groups without breaking references |
| `firestore-indexes` | Keeps Firestore composite indexes in sync when queries change |
| `organize` | Turns a rough prompt into a confirmed task brief, then executes it with an explore, plan, execute workflow |
| `readme-crafter` | Writes or rewrites a README to work for humans, search engines, and AI answer engines (it wrote this one) |
| `spec-driven-dev` | Breaks requirements docs into markdown specs and develops against them phase by phase |

Two folders stay in the repo only, nothing links to them:

- [docs/note.md](docs/note.md) - notes on the decisions behind this setup. Main ones: don't rebuild what Claude Code already has built in, and keep CLAUDE.md short, like a memory, not a manual.
- `scripts/` - the setup and cleanup scripts used in the next section.

## Setup on a new machine

Adopting this setup? Just clone and run setup below: the symlinks point at your local clone, and nothing changes unless you `git pull`. To keep your own edits synced across devices, click **Use this template** on GitHub and clone your copy instead, since pushing needs a repo you own.

```powershell
git clone https://github.com/KennethChua1998/GlobalClaude.MD.git "$HOME\dotfiles"
& "$HOME\dotfiles\scripts\setup.ps1"
```

macOS / Linux: same clone, then `sh ~/dotfiles/scripts/setup.sh`.

Windows needs Developer Mode (or an admin shell) to create symlinks. Run setup from PowerShell, not Git Bash (`ln -s` in Git Bash silently copies instead of linking). Setup is safe to re-run any time: it backs up a real CLAUDE.md before replacing it, and links every skill in `claude-skills/`.

To switch to a different config, run `scripts/cleanup.ps1` (macOS / Linux: `scripts/cleanup.sh`) first. It removes the CLAUDE.md link, every skill link that points into this repo, and unmodified local copies of the skills. Modified copies and links to other repos are kept, and a backed-up CLAUDE.md is restored if setup made one.

## Where should a rule go?

| Tier | Lives at | Use for |
|---|---|---|
| Global instructions | `global-CLAUDE.md` | Rules that always apply: style, git discipline, security |
| Global skill | `claude-skills/<name>/` | Procedures used on demand, in any project |
| Project instructions | `<repo>/CLAUDE.md` | Facts about one repo: commands, ports, architecture |
| Project skill | `<repo>/.claude/skills/<name>/` | Procedures used only in that repo |

Quick test: would the rule still be true in a brand-new repo? If yes, it is global. Is it a habit that always applies, or a procedure for one kind of task? Habit goes in CLAUDE.md; procedure goes in a skill. Copying a rule into a second project's CLAUDE.md is the signal to make the wording generic, promote it to `global-CLAUDE.md`, and delete the local copies.

## Adding a new skill

Add `claude-skills/<name>/SKILL.md` (the frontmatter `name` must match the folder name), re-run `scripts/setup.ps1`, commit.

## Maintenance

Skim `global-CLAUDE.md` now and then; keep it around 100 lines. A rule is stale when the tech is gone, a skill replaces it, or practice contradicts it. Delete stale rules in normal commits; git history keeps the old text.
