# awesome-agent-skills

Portable agent skills for Claude Code, OpenAI Codex, and Claude.ai. Built on the open [Agent Skills standard](https://agentskills.io).

## Skills

| Skill | Description |
| --- | --- |
| [`repo-snapshot`](repo-snapshot) | Summarizes the current git repo: branch, status, recent commits, file mix |
| [`commit-message`](commit-message) | Drafts a Conventional Commits message from staged changes |
| [`svg-creator`](svg-creator/skills/svg-creator) | Creates, edits, and validates SVGs: icons, logos, illustrations, diagrams |
| [`supabase`](supabase) | Runs SQL against Supabase via the management API: queries, schema changes, RLS, migrations |
| [`better-memory`](better-memory) | Stores and recalls project memories as JSON, organized by project and tags |

Click a skill name for usage details and examples.

## Install

### Claude Code

```text
/plugin marketplace add jawwadfirdousi/awesome-agent-skills
/plugin install repo-snapshot@awesome-agent-skills
/plugin install commit-message@awesome-agent-skills
/plugin install svg-creator@awesome-agent-skills
/plugin install supabase@awesome-agent-skills
/plugin install better-memory@awesome-agent-skills
```

### Codex

```text
$skill-installer install https://github.com/jawwadfirdousi/awesome-agent-skills/tree/main/repo-snapshot/skills/repo-snapshot
$skill-installer install https://github.com/jawwadfirdousi/awesome-agent-skills/tree/main/commit-message/skills/commit-message
$skill-installer install https://github.com/jawwadfirdousi/awesome-agent-skills/tree/main/svg-creator/skills/svg-creator
$skill-installer install https://github.com/jawwadfirdousi/awesome-agent-skills/tree/main/supabase/skills/supabase
$skill-installer install https://github.com/jawwadfirdousi/awesome-agent-skills/tree/main/better-memory/skills/better-memory
```

Restart Codex after install.

### Claude.ai (consumer)

ZIP upload only — no GitHub URL install.

```bash
git clone https://github.com/jawwadfirdousi/awesome-agent-skills.git
cd awesome-agent-skills/repo-snapshot/skills && zip -r repo-snapshot.zip repo-snapshot
```

Upload at [claude.ai/customize/skills](https://claude.ai/customize/skills) (`+` → `+ Create skill` → `Upload a skill`). Repeat with `commit-message/skills/commit-message`, `svg-creator/skills/svg-creator`, `supabase/skills/supabase`, and `better-memory/skills/better-memory`.

## Uninstall

### Claude Code

```text
/plugin uninstall repo-snapshot@awesome-agent-skills
/plugin uninstall commit-message@awesome-agent-skills
/plugin uninstall svg-creator@awesome-agent-skills
/plugin uninstall supabase@awesome-agent-skills
/plugin uninstall better-memory@awesome-agent-skills
/plugin marketplace remove awesome-agent-skills        # removes ALL skills from this marketplace
```

Run `/reload-plugins` to apply. Use `/plugin disable …` instead to keep the skill but turn it off.

### Codex

```bash
rm -rf ~/.codex/skills/repo-snapshot
rm -rf ~/.codex/skills/commit-message
rm -rf ~/.codex/skills/svg-creator
rm -rf ~/.codex/skills/supabase
rm -rf ~/.codex/skills/better-memory
```

Restart Codex. To disable without deleting, add to `~/.codex/config.toml`:

```toml
[[skills.config]]
name = "repo-snapshot"
enabled = false
```

### Claude.ai

[claude.ai/customize/skills](https://claude.ai/customize/skills) → click `…` next to the skill → **Delete**. Or toggle off to disable.

## License

MIT — see [LICENSE](LICENSE).
