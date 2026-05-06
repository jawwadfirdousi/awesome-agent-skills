---
name: repo-snapshot
description: Summarizes the current git repository — branch, status, recent commits, and file mix. Use when the user asks for an overview of the repo, what kind of project this is, what's been happening recently, or to brief the agent on a new codebase.
allowed-tools: Bash(git:*)
license: MIT
---

# Repo snapshot

Give the user a concise summary of the current git repository.

## Steps

1. **Confirm it's a git repo.** Run `git rev-parse --abbrev-ref HEAD`. If it errors (e.g., "not a git repository"), say so plainly and stop.

2. **Gather data.** Run each of these and read the output. Don't worry if some return nothing — that's part of the picture.
   - `git rev-parse --abbrev-ref HEAD` — current branch
   - `git remote get-url origin` — remote URL (may be missing)
   - `git status --short` — pending changes (truncate display to ~30 lines if longer)
   - `git log --oneline -10` — recent commits (may be empty if no commits yet)
   - `git ls-files | awk -F/ '{print $NF}' | awk -F. 'NF>1{print "."$NF}' | sort | uniq -c | sort -rn | head -10` — top file extensions

3. **Summarize in 3–5 sentences:**
   - What kind of project this looks like, inferred from the file mix (language, framework signals).
   - Branch state — clean vs. dirty, anything notable in `git status`.
   - What's been happening recently based on commit messages.
   - Anything unusual worth flagging (no commits yet, no remote, large pending changes).

Don't invent details that aren't supported by the data you saw.
