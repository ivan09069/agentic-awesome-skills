# Skill packs (this fork)

Curated subsets so agents load **how you work**, not the full 1,800+ catalog.

## Best option (this machine)

**Primary agent: Grok Build** → skills install to `~/.grok/skills` by default.

Also mirrored to `~/.agents/skills` for OpenClaw / other tools. Grok discovers both;
`~/.grok/skills` wins on name conflicts.

Meta skill for your operating style: **`/ivan-workflow`** (lives in `~/.grok/skills/ivan-workflow`).

## Packs

| Pack | Skills | Default for | File |
|------|--------|-------------|------|
| **Ivan Core** (recommended) | 40 | Grok + your stack | [`ivan-core.json`](./ivan-core.json) |
| Personal Core (legacy) | 30 | Generic starter — superseded | [`personal-core.json`](./personal-core.json) |

Read **[PROFILE.md](./PROFILE.md)** for why Ivan Core is shaped the way it is.

## Quick install (Windows)

```powershell
cd C:\openclaw\antigravity-awesome-skills

# BEST DEFAULT → %USERPROFILE%\.grok\skills  (Grok Build)
.\packs\install-ivan-core.ps1

# Grok + OpenClaw agents path only (no Claude / Cursor)
.\packs\install-ivan-core.ps1 -Target all

# Refresh + prune non-pack skills (Grok builtins protected)
.\packs\install-ivan-core.ps1 -Target grok -Prune
```

Claude Code and Cursor are **out of scope** — not install targets, and Grok’s `compat.claude` / `compat.cursor` skill scans are disabled in `~/.grok/config.toml`.

Uses **local copy** from this checkout (fast). Add `-UseNetworkInstaller` only if you want the official clone-from-tag flow.

Verify:

```powershell
grok inspect
# Skills section should list Ivan Core skills as "user"
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
