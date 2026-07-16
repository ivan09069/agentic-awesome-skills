# Personal skill packs

Curated subsets of this fork so agents load **what you use**, not the full 1,800+ catalog.

## Packs

| Pack | Skills | File |
|------|--------|------|
| **Personal Core** | ~30 | [`personal-core.json`](./personal-core.json) |

### Personal Core groups

1. **Essentials** — plan, TDD, lint, debug, git  
2. **Full-stack** — senior FS, FE/BE, API, DB, e2e  
3. **Web** — design, React/Next, Tailwind, SEO  
4. **DevOps** — Docker, CI/CD, deploy, bash, env setup  
5. **Agents** — prompts, agent architecture, MCP, RAG, eval  
6. **Security** — auditor, threat model, OWASP top web, code review  

## Install (Windows PowerShell)

From the repo root (after `npm ci`):

```powershell
# Default: OpenClaw/Antigravity-style global skills dir
.\packs\install-personal-core.ps1

# Claude Code
.\packs\install-personal-core.ps1 -Target claude

# Cursor project skills
.\packs\install-personal-core.ps1 -Target cursor

# Custom path
.\packs\install-personal-core.ps1 -Path "$env:USERPROFILE\.agents\skills"
```

Equivalent one-liner (installer CLI):

```powershell
node tools/bin/install.js --path "$env:USERPROFILE\.agents\skills" --skills (Get-Content packs/personal-core.json | ConvertFrom-Json).install.skills_csv
```

Or via published upstream package (always current public catalog):

```powershell
npx agentic-awesome-skills --path "$env:USERPROFILE\.agents\skills" --skills concise-planning,test-driven-development,...
```

## Edit the pack

1. Edit skill ids in `packs/personal-core.json` (must exist under `skills/<id>/`).  
2. Re-run the install script.  
3. Prefer **small packs** — large skill sets overload agent context.

## Sync note

This fork tracks upstream `sickn33/agentic-awesome-skills`. After a future upstream sync, re-run install if skill ids changed.
