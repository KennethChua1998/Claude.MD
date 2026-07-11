---
name: firestore-indexes
description: Firestore composite index workflow. Use when adding or removing a Firestore .where().orderBy() query, editing firestore.indexes.json, hitting FAILED_PRECONDITION index errors, or deploying Firebase indexes.
---

# Firestore composite indexes - never silently

Firestore raises `FAILED_PRECONDITION` for missing composite indexes only when the query first runs in production - health checks pass, smoke tests pass, then a user clicks something and takes the hit. The combination below ensures missing indexes can't ship silently:

1. **Indexes live in `firestore.indexes.json`** committed to the repo, deployed via `firebase deploy --only firestore:indexes`. That command also deletes indexes not present in the file - handy for purging dead ones. Any `firebase deploy` mutates the live project and can delete server-side indexes: run it only with explicit user go-ahead, same as a git push.
2. **Pair every composite index with a canary** in a `validateRequiredIndexes.js` (or equivalent) helper. One representative query per index using a sentinel like `__index_canary__` for the tenant id / scope field. Caught `FAILED_PRECONDITION` → log the affected query + create-here URL → `process.exit(1)`.
3. **Wire the validator into server startup** before `app.listen`. Missing indexes refuse the port bind; load balancer marks the revision unhealthy; deploy rolls back automatically.
4. **`SKIP_INDEX_CHECK=true`** escape hatch for fresh-project iteration only. Log loudly when set.

**Do NOT** suggest rewriting Firestore queries to fetch-all-and-sort-in-memory as a way to avoid composite indexes unless the user explicitly asks for that tradeoff. The startup check is the answer to "missing indexes fail silently," not the perf-degrading rewrite.

**Workflow reminder** when adding a new `.where().orderBy()` query:

- Add the composite index entry to `firestore.indexes.json`
- Add the matching canary to `validateRequiredIndexes.js`
- Deploy indexes before deploying code (`firebase deploy --only firestore:indexes` first)

**Workflow reminder** when removing the last query that used an index:

- Drop the entry from `firestore.indexes.json`
- Drop the matching canary
- Run `firebase deploy --only firestore:indexes` so the now-unused index gets cleaned up server-side (every composite taxes write throughput)
