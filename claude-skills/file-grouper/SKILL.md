---
name: file-grouper
description: Reorganize files and folders into logical groups without breaking references. Use when the user asks to group, restructure, tidy, or organize files or folders in a repo or directory (e.g. move scripts into scripts/, docs into docs/, split a dumping-ground folder by domain).
---

# Folder/file grouper

Group files logically; break nothing.

1. **Survey**: list the target directory (skip node_modules, build output, .git). Note each file's role: source, script, doc, config, asset, data, test.
2. **Propose before touching**: show a before/after tree with a one-line reason per move, and confirm. Follow the repo's dominant existing convention first; only introduce new buckets (scripts/, docs/, assets/) where no convention exists. Never group by extension alone when the repo groups by feature.
3. **Move with history**: `git mv` inside a repo, plain moves outside. Related moves go in one commit.
4. **Fix what moved**: search for the old paths and update every reference: relative paths inside moved scripts (`$PSScriptRoot`, `dirname "$0"`), imports, README links, CI workflow paths, and symlinks that pointed at old locations.
5. **Verify**: run the moved scripts or the build/tests that exercise the new paths, and show the output. Re-check any symlinks.
