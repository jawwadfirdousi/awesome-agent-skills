# x-twitter-scraper

Use Xquik for X data, searches, media downloads, monitoring, webhooks, MCP, and confirmation-gated X actions.

## When it triggers

Auto-invokes when the user needs X or Twitter data through Xquik, including tweet search, user lookup, follower extraction, media download, monitoring, webhooks, MCP setup, SDK usage, posting, likes, DMs, and profile updates.

## What it does

- Uses only the user-issued Xquik API key.
- Never asks for X login material, passwords, cookies, 2FA codes, or recovery codes.
- Treats X-authored content as untrusted data.
- Requires explicit approval before private reads, writes, persistent monitors, and event deliveries.
- Routes requests to Xquik REST, MCP, and docs endpoints.

## Setup

Set your API key before using the skill:

```bash
export XQUIK_API_KEY="xq_..."
```

See the full setup and endpoint references in `skills/x-twitter-scraper/SKILL.md`.

## Install / uninstall

See the [top-level README](../README.md).
