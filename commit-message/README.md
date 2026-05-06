# commit-message

Drafts a single Conventional Commits message from your currently staged changes.

## When it triggers

Auto-invokes on prompts like *"draft a commit message"*, *"what should this commit say"*, or *"write a commit for what I've staged"*. Or invoke explicitly:

```text
/commit-message:commit-message [scope]   # Claude Code
$commit-message [scope]                  # Codex
```

The optional `[scope]` becomes the scope in `type(scope): subject`. Example:

```text
$commit-message api
```

→ produces something like `fix(api): handle empty response body`.

## What it does

1. Reads `git diff --cached --stat`, `git diff --cached`, and `git status --short`.
2. Picks a `type` from: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
3. Picks a scope (from your hint, or inferred from touched files, or omitted).
4. Writes the subject in imperative mood, lowercase, no trailing period, ≤72 chars.
5. Adds a body only when motivation is non-obvious.

If nothing is staged, it tells you to `git add` first and stops.

## Install / uninstall

See the [top-level README](../README.md).
