# awesome-agent-skills

A small collection of agent skills following the open [Agent Skills standard](https://agentskills.io). The `SKILL.md` files are portable and work in any compliant agent. This repo provides three install paths:

- **Claude Code** (the CLI) — one-command marketplace install
- **OpenAI Codex** (the CLI) — `$skill-installer` from GitHub URL
- **Claude.ai** (the consumer chat product) — ZIP upload via the UI

These are three different products with different install mechanisms, but the underlying `SKILL.md` files are the same.

Currently includes two skills:

| Skill            | What it does                                                              |
| ---------------- | ------------------------------------------------------------------------- |
| `repo-snapshot`  | Summarizes the current git repo: branch, status, recent commits, file mix |
| `commit-message` | Drafts a Conventional Commits message from the currently staged changes   |

## Install (Claude Code CLI)

Each skill installs independently. Run inside Claude Code (the CLI, not Claude.ai):

```text
/plugin marketplace add jawwadfirdousi/awesome-agent-skills
/plugin install repo-snapshot@awesome-agent-skills
/plugin install commit-message@awesome-agent-skills
```

Install just one if that's all you want. After installing, run `/plugin marketplace update` any time to pull the latest version.

### Pin to a tag or branch

```text
/plugin marketplace add jawwadfirdousi/awesome-agent-skills@v0.1.0
```

### Install via git URL

```text
/plugin marketplace add https://github.com/<your-user>/awesome-agent-skills.git
```

### Try without installing

```bash
git clone https://github.com/jawwadfirdousi/awesome-agent-skills.git
claude --plugin-dir ./awesome-agent-skills/repo-snapshot
```

## Install (Codex)

Each skill installs independently via Codex's bundled `$skill-installer` skill. From inside a Codex session:

```text
$skill-installer install https://github.com/jawwadfirdousi/awesome-agent-skills/tree/main/repo-snapshot/skills/repo-snapshot
$skill-installer install https://github.com/jawwadfirdousi/awesome-agent-skills/tree/main/commit-message/skills/commit-message
```

Each URL points to a directory whose basename becomes the installed skill's name, and that directory contains `SKILL.md` directly — which is what `$skill-installer` requires. Skills land in `$CODEX_HOME/skills/<name>/` (defaults to `~/.codex/skills/`). Restart Codex after installing.

## Install (Claude.ai consumer)

Claude.ai's consumer product (https://claude.ai) installs skills as ZIP uploads, not GitHub URLs. To install one of these skills there:

```bash
git clone https://github.com/jawwadfirdousi/awesome-agent-skills.git
cd awesome-agent-skills/repo-snapshot/skills
zip -r repo-snapshot.zip repo-snapshot
# then go to https://claude.ai/customize/skills
# click + → + Create skill → Upload a skill, and pick the .zip
```

Repeat with `commit-message/skills/commit-message` for the other skill. Only the inner `<skill>/skills/<name>/` directory needs to be in the ZIP — the `.claude-plugin/` folders are Claude Code-only and Claude.ai will ignore them.

## Install (any other compatible agent)

Drop a skill directory into the agent's local skills folder (paths vary by tool — check your agent's docs). The portable `SKILL.md` doesn't rely on Claude-Code-specific features like `!`shell injection`` or `$ARGUMENTS`; it instructs the agent to run git commands itself.

```bash
git clone https://github.com/jawwadfirdousi/awesome-agent-skills.git
# Example, Codex:
mkdir -p ~/.codex/skills
cp -r awesome-agent-skills/repo-snapshot/skills/repo-snapshot ~/.codex/skills/
cp -r awesome-agent-skills/commit-message/skills/commit-message ~/.codex/skills/
```

## Uninstall (Claude Code CLI)

Remove a single skill (plugin):

```text
/plugin uninstall repo-snapshot@awesome-agent-skills
/plugin uninstall commit-message@awesome-agent-skills
```

Disable a skill temporarily without removing it (re-enable later with `/plugin enable …`):

```text
/plugin disable repo-snapshot@awesome-agent-skills
/plugin enable repo-snapshot@awesome-agent-skills
```

Remove the marketplace entirely. **This also uninstalls every plugin you installed from it**, so use it when you want to wipe all of these skills at once:

```text
/plugin marketplace remove awesome-agent-skills
```

Run `/reload-plugins` after any of these so the change takes effect in the current session. List what's currently installed any time with `/plugin` (the **Installed** tab) or `/plugin marketplace list` for marketplaces.

CLI-scoped uninstall (when you installed at project or local scope rather than the default user scope):

```bash
claude plugin uninstall repo-snapshot@awesome-agent-skills --scope project
```

## Uninstall (Codex)

There's no first-party `$skill-installer` uninstall flow. Skills land in `$CODEX_HOME/skills/<name>/` (defaults to `~/.codex/skills/`), so removing them means deleting that directory:

```bash
rm -rf ~/.codex/skills/repo-snapshot
rm -rf ~/.codex/skills/commit-message
```

Restart Codex afterwards.

To disable a skill without deleting it, add an entry to `~/.codex/config.toml`:

```toml
[[skills.config]]
name = "repo-snapshot"
enabled = false
```

You can use either a `name` selector (matches the skill's frontmatter `name` / directory name, as shown above) or a `path` selector with the absolute path to the skill's `SKILL.md` file — but not both in the same entry. Restart Codex after editing the config.

## Uninstall (Claude.ai consumer)

Go to **[Customize > Skills](https://claude.ai/customize/skills)**:

- **Disable**: toggle the switch off next to the skill — the skill stays in your library but Claude won't use it.
- **Delete**: click the `…` button next to the toggle, then **Delete** to remove the skill permanently.

If a skill was provisioned by your organization owner, you can only toggle it off — only owners can delete org-deployed skills.

## Use

In Claude Code (skills are namespaced by the plugin name):

```text
/repo-snapshot:repo-snapshot
/commit-message:commit-message
```

In Codex (skills are invoked with `$`, not `/`):

```text
$repo-snapshot
$commit-message
```

Or just ask in plain English — any compliant agent will load the matching skill based on its `description`. Examples: *"give me a quick overview of this repo"* or *"draft a commit message for what I've staged"*.

`commit-message` accepts an optional scope hint when invoked. The skill instructions tell the agent to use whatever you typed after the skill name as the commit scope:

```text
/commit-message:commit-message api    # Claude Code
$commit-message api                   # Codex
```

## Repository layout

```
.
├── .claude-plugin/
│   └── marketplace.json              # Claude Code marketplace catalog (one entry per skill)
├── repo-snapshot/                    # Top-level dir per skill — also a Claude Code plugin
│   ├── .claude-plugin/
│   │   └── plugin.json
│   └── skills/repo-snapshot/SKILL.md
└── commit-message/
    ├── .claude-plugin/plugin.json
    └── skills/commit-message/SKILL.md
```

Each top-level directory (`repo-snapshot/`, `commit-message/`) is one skill. The internal `skills/<name>/SKILL.md` nesting is required by Claude Code's plugin layout — it's where Claude Code discovers skills inside a plugin. Other agents (Codex, etc.) just install from that inner path directly.

## Add a new skill

Keep new skills portable: write `SKILL.md` against the [open Agent Skills spec](https://agentskills.io/specification) (`name` and `description` required) and avoid Claude-Code-only features like `!`shell injection``, `$ARGUMENTS`, `argument-hint`, or `disable-model-invocation`. Tell the agent to run any commands itself instead of pre-rendering them.

1. Create a new top-level directory for the skill: `<your-skill>/`.
2. Add `<your-skill>/.claude-plugin/plugin.json`:

   ```json
   {
     "name": "<your-skill>",
     "description": "...",
     "version": "0.1.0",
     "license": "MIT"
   }
   ```

3. Add the skill itself at `<your-skill>/skills/<your-skill>/SKILL.md`:

   ```yaml
   ---
   name: <your-skill>            # must match the directory name
   description: What it does and when to use it.
   allowed-tools: Bash(git:*)    # optional, experimental in the spec
   license: MIT
   ---
   ```

4. Add a new entry to the `plugins` array in `.claude-plugin/marketplace.json`:

   ```json
   {
     "name": "<your-skill>",
     "source": "./<your-skill>",
     "description": "..."
   }
   ```

5. Bump the `version` in your plugin's `plugin.json` whenever you ship changes — Claude Code uses it to decide if a re-install is needed. (Omit `version` to let the git commit SHA stand in.)

Validate locally before pushing:

```bash
claude plugin validate .
claude --plugin-dir ./<your-skill>   # smoke-test
```

## License

MIT — see [LICENSE](LICENSE).
