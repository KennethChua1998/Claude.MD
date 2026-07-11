#!/usr/bin/env sh
# Removes the ~/.claude symlinks created by setup.sh and unmodified local copies of them.
# Modified copies and links into other repos are kept.
set -e
repo="$(cd "$(dirname "$0")/.." && pwd)"

unlink_ours() {
    path="$1"
    src="$2"
    [ -e "$path" ] || [ -L "$path" ] || return 0
    if [ ! -L "$path" ]; then
        if diff -rq "$src" "$path" >/dev/null 2>&1; then
            rm -rf "$path"
            echo "removed copy: $path"
        else
            echo "kept (differs from repo): $path"
        fi
        return 0
    fi
    case "$(readlink "$path")" in
        "$repo"*) rm "$path"; echo "unlinked: $path" ;;
        *) echo "kept (links elsewhere): $path" ;;
    esac
}

unlink_ours "$HOME/.claude/CLAUDE.md" "$repo/global-CLAUDE.md"
for d in "$repo"/claude-skills/*/; do
    unlink_ours "$HOME/.claude/skills/$(basename "$d")" "${d%/}"
done

if [ -f "$HOME/.claude/CLAUDE.md.bak" ] && [ ! -e "$HOME/.claude/CLAUDE.md" ]; then
    mv "$HOME/.claude/CLAUDE.md.bak" "$HOME/.claude/CLAUDE.md"
    echo "restored: ~/.claude/CLAUDE.md (from .bak)"
fi
