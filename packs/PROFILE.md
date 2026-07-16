# Ivan workflow profile → skill pack

This is how the **Ivan Core** pack was shaped. Revisit when your stack changes.

## How you actually work

| Surface | Evidence | Pack response |
|---------|----------|---------------|
| **OpenClaw** monorepo | `C:\openclaw` TS/pnpm, gateway, UI, skills | typescript-expert, monorepo-management, nodejs-best-practices, electron-development |
| **Hermes agent** | `hermes-agent` fork, `.hermes`, Python core | python-pro, pytest-skill, ai-agents-architect, agent-memory-systems, backend-dev-guidelines |
| **Windows first** | OS + PowerShell shells | powershell-windows, windows-shell-reliability |
| **GitHub-native loop** | many forks/PRs, issue-whisperer, review flow | create-pr, address-github-comments, git-pr-review, requesting-code-review |
| **Multi-agent coding** | Cursor + Claude + Codex + OpenClaw + Hermes | prompt-engineering, agent-evaluation, mcp-builder |
| **MCP stacks** | compliance / cex-exec / tradememory / loop / cdp-wallet | mcp-builder, mcp-tool-developer |
| **Crypto / fintech** | EchoForge, trading MCPs, eth tooling | trading-ledger, fsi-compliance-checker, security-auditor, api-security-best-practices |
| **CI on large repos** | Actions-heavy forks | github-actions-debugger, ci-cd-and-automation, docker-expert |

## What we deliberately dropped from the generic pack

Generic “web startup” skills that rarely match your agent/infra day:

- SEO / Tailwind-only design packs  
- Broad pen-test style skills (burp, privilege escalation)  
- Generic bash/linux env bootstrap (you’re Windows-primary)  
- Catch-all senior-fullstack / database design when architecture + TS/Python specialists cover better  

## Install (Grok-first)

```powershell
cd C:\openclaw\antigravity-awesome-skills
.\packs\install-ivan-core.ps1                 # DEFAULT → ~/.grok/skills
.\packs\install-ivan-core.ps1 -Target all     # Grok + ~/.agents/skills
.\packs\install-ivan-core.ps1 -Target claude
.\packs\install-ivan-core.ps1 -Target cursor
.\packs\install-ivan-core.ps1 -Target hermes
.\packs\install-ivan-core.ps1 -Prune          # drop non-pack skills (builtins kept)

grok inspect   # confirm skills visible
# In Grok: /ivan-workflow  or  /typescript-expert  etc.
```

## Editing the pack

1. Edit skill ids in `packs/ivan-core.json`  
2. Keep groups annotated with **why** (future-you will thank you)  
3. Re-run install with `-Prune` so agents don’t drown in stale skills  

## Sync

Fork tracks upstream `sickn33/agentic-awesome-skills` @ v14.5.0+. After a big upstream sync, re-validate ids and reinstall.
