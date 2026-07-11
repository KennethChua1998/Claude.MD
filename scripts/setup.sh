#!/usr/bin/env sh
# Links ~/.claude to this repo. Idempotent; re-run after adding a skill.
set -e
repo="$(cd "$(dirname "$0")/.." && pwd)"

mkdir -p "$HOME/.claude/skills"

if [ -f "$HOME/.claude/CLAUDE.md" ] && [ ! -L "$HOME/.claude/CLAUDE.md" ]; then
    cp "$HOME/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md.bak"
    echo "backed up: ~/.claude/CLAUDE.md.bak"
fi
ln -sfn "$repo/global-CLAUDE.md" "$HOME/.claude/CLAUDE.md"
echo "linked: ~/.claude/CLAUDE.md"

for d in "$repo"/claude-skills/*/; do
    name="$(basename "$d")"
    ln -sfn "${d%/}" "$HOME/.claude/skills/$name"
    echo "linked: ~/.claude/skills/$name"
done
