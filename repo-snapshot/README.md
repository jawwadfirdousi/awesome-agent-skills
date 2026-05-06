# repo-snapshot

Summarizes the current git repository: branch, status, recent commits, and file mix.

## When it triggers

Auto-invokes on prompts like *"give me a quick overview of this repo"*, *"what kind of project is this"*, or *"what's been happening lately"*. Or invoke explicitly:

```text
/repo-snapshot:repo-snapshot   # Claude Code
$repo-snapshot                 # Codex
```

## What it does

Runs read-only git commands and summarizes the output in 3–5 sentences:

- `git rev-parse --abbrev-ref HEAD` — current branch
- `git remote get-url origin` — remote
- `git status --short` — pending changes
- `git log --oneline -10` — recent commits
- `git ls-files | …` — top file extensions

If it isn't a git repo, the skill says so and stops.

## Install / uninstall

See the [top-level README](../README.md).
