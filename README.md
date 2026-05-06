# awesome-agent-skills

Portable agent skills for Claude Code, OpenAI Codex, and Claude.ai. Built on the open [Agent Skills standard](https://agentskills.io).

## Skills

| Skill | Description |
| --- | --- |
| [`repo-snapshot`](repo-snapshot) | Summarizes the current git repo: branch, status, recent commits, file mix |
| [`commit-message`](commit-message) | Drafts a Conventional Commits message from staged changes |

Click a skill name for usage details and examples.

## Install

### Claude Code

```text
/plugin marketplace add jawwadfirdousi/awesome-agent-skills
/plugin install repo-snapshot@awesome-agent-skills
/plugin install commit-message@awesome-agent-skills
```

### Codex

```text
$skill-installer install https://github.com/jawwadfirdousi/awesome-agent-skills/tree/main/repo-snapshot/skills/repo-snapshot
$skill-installer install https://github.com/jawwadfirdousi/awesome-agent-skills/tree/main/commit-message/skills/commit-message
```

Restart Codex after install.

### Claude.ai (consumer)

ZIP upload only — no GitHub URL install.

```bash
git clone https://github.com/jawwadfirdousi/awesome-agent-skills.git
cd awesome-agent-skills/repo-snapshot/skills && zip -r repo-snapshot.zip repo-snapshot
```

Upload at [claude.ai/customize/skills](https://claude.ai/customize/skills) (`+` → `+ Create skill` → `Upload a skill`). Repeat for `commit-message/skills/commit-message`.

## Uninstall

### Claude Code

```text
/plugin uninstall repo-snapshot@awesome-agent-skills
/plugin uninstall commit-message@awesome-agent-skills
/plugin marketplace remove awesome-agent-skills        # removes ALL skills from this marketplace
```

Run `/reload-plugins` to apply. Use `/plugin disable …` instead to keep the skill but turn it off.

### Codex

```bash
rm -rf ~/.codex/skills/repo-snapshot
rm -rf ~/.codex/skills/commit-message
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
