# Install / refresh the Ivan-tailored skill pack for Grok (default) and other agents.
#
# Best option for this machine: Grok Build primary → ~/.grok/skills
# Also supports: agents, claude, cursor, codex, hermes, custom
param(
  [ValidateSet("grok", "agents", "all", "custom")]
  [string]$Target = "grok",
  [string]$Path = "",
  [switch]$Prune,
  [switch]$UseNetworkInstaller
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

$packPath = Join-Path $PSScriptRoot "ivan-core.json"
if (-not (Test-Path $packPath)) { throw "Missing $packPath" }
$pack = Get-Content $packPath -Raw | ConvertFrom-Json
$skillsCsv = $pack.install.skills_csv
$skillIds = @($skillsCsv -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })

# Never prune these (Grok / system skills)
$Protected = [System.Collections.Generic.HashSet[string]]::new([string[]]@(
  "check-work", "code-review", "create-skill", "docx", "help", "imagine",
  "pptx", "xlsx", "build-with-ai", "design", "execute-plan", "implement",
  "pr-babysit", "resume-claude", "resume-codex", "resume-cursor", "review",
  "docs"
))

function Resolve-TargetPath([string]$t) {
  switch ($t) {
    "grok"   { return (Join-Path $env:USERPROFILE ".grok\skills") }
    "agents" { return (Join-Path $env:USERPROFILE ".agents\skills") }  # OpenClaw only; not Claude/Cursor
    default  { throw "Unknown target: $t (supported: grok, agents, all, custom)" }
  }
}

function Install-LocalCopy([string]$dest, [string[]]$ids) {
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  $missing = @()
  foreach ($id in $ids) {
    $src = Join-Path $Root "skills\$id"
    if (-not (Test-Path $src)) { $missing += $id; continue }
    $target = Join-Path $dest $id
    if (Test-Path $target) { Remove-Item -Recurse -Force $target }
    Copy-Item -Recurse -Force $src $target
  }
  if ($missing.Count -gt 0) {
    throw "Missing skills in local catalog: $($missing -join ', ')"
  }
}

function Install-Network([string]$dest, [string]$csv) {
  if (-not (Test-Path (Join-Path $Root "node_modules"))) {
    Write-Host "Running npm ci..."
    npm ci
  }
  node tools/bin/install.js --path $dest --skills $csv
  if ($LASTEXITCODE -ne 0) { throw "network installer failed with exit $LASTEXITCODE" }
}

function Invoke-Prune([string]$dest, [string[]]$ids) {
  if (-not (Test-Path $dest)) { return }
  $keep = [System.Collections.Generic.HashSet[string]]::new([string[]]$ids)
  foreach ($p in $Protected) { [void]$keep.Add($p) }
  Get-ChildItem $dest -Directory | ForEach-Object {
    if (-not $keep.Contains($_.Name)) {
      Write-Host "  Prune: $($_.Name)"
      Remove-Item -Recurse -Force $_.FullName
    }
  }
}

$targets = @()
if ($Target -eq "all") {
  $targets = @("grok", "agents")
} elseif ($Target -eq "custom") {
  if (-not $Path) { throw "Pass -Path when -Target custom" }
  $targets = @(@{ Name = "custom"; Path = $Path })
} else {
  $targets = @($Target)
}

Write-Host "Pack:   $($pack.name) v$($pack.version) ($($pack.id))"
Write-Host "Skills: $($skillIds.Count)"
Write-Host "Mode:   $(if ($UseNetworkInstaller) { 'network (clone upstream tag)' } else { 'local copy from this checkout (fast)' })"
Write-Host "Primary consumer: Grok Build (~/.grok/skills)"
Write-Host ""

foreach ($t in $targets) {
  $dest = if ($t -is [hashtable]) { $t.Path } else { Resolve-TargetPath $t }
  $label = if ($t -is [hashtable]) { "custom" } else { $t }
  Write-Host "→ Installing to [$label] $dest"

  if ($UseNetworkInstaller) {
    Install-Network $dest $skillsCsv
  } else {
    Install-LocalCopy $dest $skillIds
  }

  if ($Prune) {
    Write-Host "  Pruning non-pack skills (protected Grok builtins kept)..."
    Invoke-Prune $dest $skillIds
  }

  $count = (Get-ChildItem $dest -Directory -ErrorAction SilentlyContinue | Measure-Object).Count
  Write-Host "  Done ($count skill dirs).`n"
}

Write-Host "Next: run  grok inspect  and confirm Ivan Core skills appear under Skills."
Write-Host "Slash: type / then a skill name (e.g. /typescript-expert, /create-pr)."
Write-Host "Tip:   .\packs\install-ivan-core.ps1 -Target all   # grok + OpenClaw agents path only"
