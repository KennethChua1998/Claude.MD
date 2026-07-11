---
name: readme-crafter
description: Write or rewrite a README so it works for humans, search engines (SEO), and AI answer engines (GEO). Use when the user asks to create, improve, or optimize a README, a repo description, or GitHub topics.
---

# README crafter

A README serves three readers at once: a human skimming, a search engine indexing, and an AI engine quoting. Write for all three.

## Structure

1. **Title**: project name plus a plain statement of what it is, using the words people would actually search for.
2. **Intro paragraph**: what it does, who it is for, and any trust marker (license, no-secrets note). Three sentences max.
3. **"What is X?" lines** for terms a newcomer may not know. Self-contained sentences; AI engines quote these directly.
4. **What's inside**: layout as a table; a short bullet list for anything not in the table.
5. **Setup**: copy-paste commands per OS, with gotchas stated plainly (permissions, shell differences).
6. **Usage or rules**: tables for structure, one short plain paragraph for the reasoning.
7. Maintenance/contributing sections only if the repo genuinely needs them.

## Language rules

- Short sentences. Plain international English. No idioms, no filler words.
- Each sentence should still be true and clear if lifted out alone.
- Explain jargon at first use, or delete it.
- Dense semicolon-and-parentheses sentences get split into bullets.

## Beyond the file

- **Repo description**: one line, under 120 characters, says what it is and any trust marker. Set with `gh repo edit --description`.
- **GitHub topics**: 4 to 8 lowercase keywords via `gh repo edit --add-topic`. Topics do more for discovery than keywords in prose.
- Verify every link and command in the README actually works before committing.
