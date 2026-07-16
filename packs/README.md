# Skill packs (this fork)

Curated subsets so agents load **how you work**, not the full 1,800+ catalog.

## Packs

| Pack | Skills | Default for | File |
|------|--------|-------------|------|
| **Ivan Core** (recommended) | 40 | Daily OpenClaw / Hermes / Windows / MCP / crypto | [`ivan-core.json`](./ivan-core.json) |
| Personal Core (legacy) | 30 | Generic starter — superseded | [`personal-core.json`](./personal-core.json) |

Read **[PROFILE.md](./PROFILE.md)** for why Ivan Core is shaped the way it is.

## Quick install (Windows)

```powershell
cd C:\openclaw\antigravity-awesome-skills

# Default → %USERPROFILE%\.agents\skills  (OpenClaw / Antigravity-style)
.\packs\install-ivan-core.ps1

# Also install where other agents look
.\packs\install-ivan-core.ps1 -Target claude
.\packs\install-ivan-core.ps1 -Target cursor
.\packs\install-ivan-core.ps1 -Target hermes

# Refresh + remove skills not in the pack
.\packs\install-ivan-core.ps1 -Prune
```

## Ivan Core groups

1. **daily_loop** — plan, debug, TDD, lint, git, PR create/review/comments  
2. **openclaw_typescript** — TS monorepo, Node, Electron, architecture, React/Next  
3. **windows_shell** — PowerShell + Windows reliability  
4. **hermes_python_agents** — Python, pytest, APIs, prompts, agent memory/eval  
5. **mcp_tooling** — MCP server/tool authoring  
6. **infra_ci** — Docker, Actions debug, Playwright, Postgres  
7. **crypto_compliance** — trading ledger, FSI compliance, API/security audit  

## Customize

Edit `packs/ivan-core.json` → re-run `install-ivan-core.ps1 -Prune`.
