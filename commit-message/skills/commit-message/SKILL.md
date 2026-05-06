---
name: commit-message
description: Drafts a Conventional Commits message from the currently staged changes. Use when the user asks for a commit message, wants to write a commit, or asks "what should this commit say". If the user supplies a scope hint when invoking this skill (e.g. "commit-message api"), use it as the commit scope.
allowed-tools: Bash(git:*)
license: MIT
---

# Commit message

Draft a single Conventional Commits message for what's currently staged.

## Steps

1. **Inspect the staged changes.** Run, in this order:
   - `git diff --cached --stat` — file-level summary
   - `git diff --cached` — full diff (if it's longer than ~300 lines, read the first 300 and note the truncation in the body)
   - `git status --short` — quick context on the working tree

2. **Bail early if nothing is staged.** If `git diff --cached` is empty, reply with `Nothing is staged. Stage changes with \`git add\` and try again.` and stop.

3. **Pick the type.** Exactly one of: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.

4. **Pick a scope.**
   - If the user passed a scope hint when invoking this skill, use it.
   - Otherwise, infer one short scope from the touched files (a top-level directory or package name) only if it's obvious. Leave the scope off when in doubt.

5. **Write the subject.** Imperative mood, lowercase, no trailing period, ≤72 characters.

6. **Add a body only if it earns its place.** Include one when the diff has non-obvious motivation worth explaining. Wrap at 72 characters. Explain *why*, not *what*.

## Output format

Output **only** the commit message, inside a single fenced code block, ready to paste into `git commit -m`:

```
type(scope): subject

optional body
```
