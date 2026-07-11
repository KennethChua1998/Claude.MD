#!/usr/bin/env sh
# Removes the ~/.claude symlinks created by setup.sh. Leaves anything this repo does not own.
set -e
repo="$(cd "$(dirname "$0")/.." && pwd)"

unlink_ours() {
    path="$1"
    [ -e "$path" ] || [ -L "$path" ] || return 0
    if [ ! -L "$path" ]; then
        echo "kept (not a symlink): $path"
        return 0
    fi
    case "$(readlink "$path")" in
        "$repo"*) rm "$path"; echo "unlinked: $path" ;;
        *) echo "kept (links elsewhere): $path" ;;
    esac
}

unlink_ours "$HOME/.claude/CLAUDE.md"
for d in "$repo"/claude-skills/*/; do
    unlink_ours "$HOME/.claude/skills/$(basename "$d")"
done

if [ -f "$HOME/.claude/CLAUDE.md.bak" ] && [ ! -e "$HOME/.claude/CLAUDE.md" ]; then
    mv "$HOME/.claude/CLAUDE.md.bak" "$HOME/.claude/CLAUDE.md"
    echo "restored: ~/.claude/CLAUDE.md (from .bak)"
fi
