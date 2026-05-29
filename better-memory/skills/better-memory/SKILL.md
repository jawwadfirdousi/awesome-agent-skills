---
name: better-memory
description: "Persistent project memory stored as JSON, scoped by project and tags. Use to recall what's already known at the start of work, capture things worth remembering after a correction, preference, or decision, and to add, list, search, update, or delete memories by tag — whenever the user says remember this, note that, what do you remember about X, or forget Y. Tags let you save and fetch precisely and bridge wording that literal search misses. Defaults to the current repo and persists across sessions."
compatibility: Requires bash and jq.
metadata:
  author: jawwadfirdousi
  version: "2.1"
---

# Better Memory

A persistent, file-based memory store. Memories are JSON entries, each scoped by a
**project** and labeled with one or more **tags**, plus a short **id**. Everything
goes through one script, `scripts/memory.sh`:

- `recall` — compact index of what's stored, including the tags in scope (run first)
- `add` — store a new memory (one or more tags required)
- `list` — list memories in full
- `search` — find memories by literal content match
- `get` — show one memory in full
- `update` — change a memory's content and/or tags
- `delete` — remove a memory, or memories in a project by tag

## Use it like memory

This store only surfaces what you ask for, so treat it as an active habit:

1. **Recall at the start of work.** Run `scripts/memory.sh recall` to load what's
   known (snippets plus the tags in scope) before acting. Pull full content with
   `get`/`list` when a snippet looks relevant.
2. **Capture what's worth keeping.** After the user corrects you, states a durable
   preference, or makes a decision worth remembering, `add` it with descriptive
   tags. Capture proactively, but only things that will matter again.
3. **Verify before you trust.** A memory naming a file, function, or flag was true
   when written and can go stale. Check it against the current code before acting,
   then `update` or `delete` if it is wrong now.

## Tags

Tags are the retrieval axis: you **save with the tags that describe a memory and
fetch by tag**. A memory can carry several.

- **Filtering by multiple `--tag` is AND**: a memory must have all the given tags.
  Narrow an ambiguous fetch by adding more tags.
- **`recall` prints "Tags in scope"** so you can see the existing vocabulary.
  Reuse exact tags (matching is case-sensitive); avoid near-duplicates like
  `db` vs `database`.
- **Combine a type tag with topic tags.** A type tag says what kind of memory it
  is (`decision`, `convention`, `gotcha`, `preference`, `reference`, `todo`); topic
  tags say what it is about (`database`, `auth`, `billing`, `letter`). Together they
  make memories findable from either angle.
- **Tags bridge wording that literal `search` misses.** A note whose text says
  "open formal correspondence with a courteous salutation" can be tagged `letter`,
  so `recall --tag letter` finds it even though `search --query letter` would not.

## Commands

```bash
# Recall: compact index (snippets + tags). --format json gives {id, project, tags, summary}.
scripts/memory.sh recall
scripts/memory.sh recall --tag letter --all

# Add: project defaults to the current repo; at least one --tag and --content required.
scripts/memory.sh add --tag decision --tag database --content "Chose Postgres over Mongo."
scripts/memory.sh add --project acme-api --tag gotcha --tag users --content "users table uses soft deletes."

# List full content, grouped by project (tags shown under each).
scripts/memory.sh list
scripts/memory.sh list --all --tag decision

# Search content literally (case-insensitive); --regex for patterns. Optional --tag filter.
scripts/memory.sh search --query postgres
scripts/memory.sh search --query salutation --all

# Get one memory (by id, or by tag(s) in scope; --all searches every project).
scripts/memory.sh get --id 1a2b3c4d
scripts/memory.sh get --tag letter --all

# Update content and/or tags (target by id, or by tag(s) in scope).
scripts/memory.sh update --id 1a2b3c4d --content "Revised note."
scripts/memory.sh update --id 1a2b3c4d --add-tag urgent --remove-tag draft

# Delete (explicit project or id only).
scripts/memory.sh delete --id 1a2b3c4d
scripts/memory.sh delete --project acme-api --tag scratch --yes
```

Re-adding the same content under the same project is a no-op (reports the existing id).

## Scope (project)

Read commands (`recall`, `list`, `search`) and `add` default the project to the
**current repo** (git repository basename, else the current directory name).
`get` and `update` use the same default when you target by `--tag`.

- `--project <name>` targets a specific project instead.
- `--all` spans every project (on `recall`/`list`/`search`, and on `get`/`update`
  when targeting by `--tag`).
- `delete` never auto-detects the project — pass `--project` or `--id` explicitly.

## Data model

Memories live in `memories.json` at the skill root (gitignored, `chmod 600`):

```json
{ "id": "1a2b3c4d", "project": "acme-api", "tags": ["decision", "database"],
  "content": "...", "created_at": "...", "updated_at": "..." }
```

Tags are de-duplicated on write.

## Targeting rules

- `--id` targets exactly one memory. Use it whenever you have the id.
- `get`/`update` accept `--tag` (in the current or `--project` scope) and act only
  when exactly one memory matches. If several match, the script lists their ids so
  you re-run with `--id` or add more `--tag` to narrow.
- `delete` takes `--id`, or `--project` optionally narrowed by `--tag` (AND); a
  multi-match delete requires `--yes`.
- `update` changes content (`--content`) and/or tags (`--add-tag`/`--remove-tag`),
  but never a memory's project; a memory must keep at least one tag.

## Mapping requests to commands

Translate what the user says into a command. When unsure, `recall` first.

| The user says | Do |
| --- | --- |
| Starting work, or "what do you know about this project?" | `recall` |
| "what do you remember about auth?" | `recall --tag auth`, then read and answer |
| "what do you remember about writing a letter?" | `recall --tag letter` (tags bridge wording `search` misses) |
| "find the note that mentions Postgres" | `search --query postgres` |
| "remember we use pnpm, not npm" | `add --tag preference --tag tooling --content "Use pnpm, not npm."` |
| "note the users table uses soft deletes" | `add --tag gotcha --tag database --content "users table uses soft deletes; filter deleted_at IS NULL."` |
| "that decision changed, we use SQS now" | find it via `recall`, then `update --id <id> --content "..."` |
| "tag that note urgent" | `update --id <id> --add-tag urgent` |
| "forget the scratch notes for this repo" | `delete --project <repo> --tag scratch` (confirm first) |

## Worked example

Capture a decision, then recall it in a later session:

```bash
# 1) The user decides something worth keeping (project auto-detected from the repo)
$ scripts/memory.sh add --tag decision --tag database \
    --content "Chose Postgres over Mongo for relational integrity."
Added memory [4f8a2c1d] under acme-api [tags: database, decision] (project auto-detected; use --project to override).

# 2) Next session, before related work, recall the current repo's memories
$ scripts/memory.sh recall
Memory index - acme-api (current repo; pass --project <name> or --all)
Tags in scope: database (1), decision (1)

acme-api  (1)
  [4f8a2c1d] Chose Postgres over Mongo for relational integrity.  #database #decision

# 3) Pull the full entry when a snippet looks relevant
$ scripts/memory.sh get --id 4f8a2c1d
```

## What to store (and not)

**Store** durable, reusable facts: decisions and their rationale, project
conventions, gotchas, user/team preferences, and pointers to external resources.

**Don't store:** secrets or tokens; facts trivially derivable by reading the code;
ephemeral task state; or one-off answers. Run `recall`/`search` before adding to
avoid near-duplicates.

## Safety

- **Deletes are destructive and permanent.** Confirm with the user before deleting
  a whole project or any multi-match (`--yes`) delete.
- **Recall or list before `update`/`delete`** to confirm the id and current content.
- **Don't fabricate memories.** Store only what is actually true and worth keeping.

## Gotchas

- Tag and project matching is exact and case-sensitive. Recall first and reuse
  existing tags rather than creating variants.
- `search` matches memory text literally, so it misses synonyms and paraphrases.
  For concept-based recall, use `recall` (and tags), not `search`.
- `recall` shows truncated snippets; `list`/`get` show full content.
- `memories.json` is read from the skill root, or `~/.config/claude/memories.json`
  if that file already exists.
- `update` can change content and tags, but never a memory's project; a memory
  must always keep at least one tag.
- A skill loads only when invoked, so this store is not auto-injected every
  session — run `recall` to bring memories into context.
```

