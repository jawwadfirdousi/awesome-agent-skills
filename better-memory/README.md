# better-memory

A persistent, file-based memory store for agents. Save facts, decisions, conventions, preferences, and context as JSON, scoped by project and labeled with tags, and recall them across sessions.

## What It Is

This skill wraps a small shell script around a single JSON file so an agent can recall, capture, search, and manage memories. Each memory is scoped by a **project** and labeled with one or more **tags**, and gets a short **id** used to target it precisely.

It is built to be used like memory: **recall** what's known at the start of work, and **capture** things worth remembering after a correction, preference, or decision. Tags are how you save and fetch precisely.

## Requirements

- `bash` and `jq`

## Setup

Nothing to configure. The store is created on first write at
`skills/better-memory/memories.json` (gitignored, `chmod 600`). A copyable
template lives at `skills/better-memory/memories.example.json`.

```bash
cd skills/better-memory

# --project is optional (defaults to the current repo); one or more --tag required
scripts/memory.sh add --tag decision --tag database \
  --content "Chose Postgres over MongoDB for relational integrity."

scripts/memory.sh recall
```

Each memory holds:

```json
{
  "id": "1a2b3c4d",
  "project": "acme-api",
  "tags": ["decision", "database"],
  "content": "Chose Postgres over MongoDB for relational integrity.",
  "created_at": "2026-05-29T10:00:00Z",
  "updated_at": "2026-05-29T10:00:00Z"
}
```

`memories.json` is read from the skill root, or from
`~/.config/claude/memories.json` if that file already exists.

## Use It Like Memory

1. **Recall first.** At the start of work, run `recall` to load what's known plus
   the tags in scope.
2. **Capture proactively.** After a correction, preference, or decision worth
   keeping, `add` it with descriptive tags.
3. **Verify before trusting.** Memories naming files or functions can go stale;
   check against current code before acting, then `update`/`delete` if wrong.

A skill loads only when invoked, so the store is not auto-injected every session —
run `recall` to bring memories into context.

## How To Use It

```bash
# Recall: compact index (snippets + tags) for the current repo
scripts/memory.sh recall
scripts/memory.sh recall --tag letter --all

# Add (project defaults to the current repo; at least one --tag and --content)
scripts/memory.sh add --tag convention --tag time --content "Timestamps stored in UTC."
scripts/memory.sh add --project acme-api --tag gotcha --tag users --content "users table uses soft deletes."

# List full content (grouped by project, tags under each)
scripts/memory.sh list
scripts/memory.sh list --all --tag decision

# Search content literally (case-insensitive; --regex for patterns)
scripts/memory.sh search --query postgres
scripts/memory.sh search --query salutation --all

# Read one memory (by id, or by tag(s) in scope; --all searches every project)
scripts/memory.sh get --id 1a2b3c4d
scripts/memory.sh get --tag letter --all

# Update content and/or tags (target by id, or by tag(s) in scope)
scripts/memory.sh update --id 1a2b3c4d --content "Revised note."
scripts/memory.sh update --id 1a2b3c4d --add-tag urgent --remove-tag draft

# Delete one memory, or memories in a project by tag (project must be explicit)
scripts/memory.sh delete --id 1a2b3c4d
scripts/memory.sh delete --project acme-api --tag scratch --yes
```

Tags:

- A memory carries one or more tags. Filtering by multiple `--tag` matches memories
  that have **all** of them (AND). Narrow an ambiguous fetch by adding tags.
- `recall` prints the tags in scope so you know what to fetch by. Matching is exact
  and case-sensitive, so reuse existing tags instead of variants (`db` vs `database`).
- Tags bridge wording that literal `search` misses: a note that says "formal
  correspondence with a courteous salutation" tagged `letter` is found by
  `recall --tag letter` even though `search --query letter` returns nothing.
- Edit tags later with `update --add-tag <t>` / `--remove-tag <t>` (a memory must
  keep at least one tag).

Scope:

1. Read commands (`recall`/`list`/`search`) and `add` default the project to the
   **current repo** (git repo basename, else the current directory).
2. `--project <name>` targets another project; `--all` spans every project (and
   applies to `get`/`update` when targeting by `--tag`).
3. `delete` never auto-detects the project — pass `--project` or `--id`.

## Recommended Tags

Combine a type tag with topic tags. Type tags: `decision`, `convention`, `gotcha`,
`preference`, `reference`, `todo`. Topic tags describe the subject: `database`,
`auth`, `billing`, `letter`, and so on.

## Common Uses

- Recording project decisions and the reasoning behind them
- Storing per-project conventions, gotchas, and constraints
- Keeping user/team preferences so they persist across sessions
- Quick scratch notes you can clear later by tag

## Example Prompts

```text
Use the better-memory skill to recall what you know about this project before we start.
```

```text
Use the better-memory skill to remember that we chose Postgres for acme-api, tagged decision and database.
```

```text
Use the better-memory skill to recall anything tagged letter.
```

## Notes

- Deletes are permanent. The skill asks the agent to confirm destructive deletes,
  and multi-match deletes require `--yes`.
- Tag and project matching is exact and case-sensitive; recall first to reuse
  existing tags.
- `recall` shows truncated snippets (the index); `list`/`get` show full content.
- `search` is literal; for concept/synonym recall use `recall` and tags.
- `memories.json` is gitignored and `chmod 600`, since memories can hold personal
  context. Keep secrets out of it.
```

