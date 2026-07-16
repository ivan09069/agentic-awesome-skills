# Install / refresh the Ivan-tailored skill pack into a local agent skills directory.
param(
  [ValidateSet("agents", "claude", "cursor", "codex", "hermes", "custom")]
  [string]$Target = "agents",
  [string]$Path = "",
  [switch]$Prune
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

$packPath = Join-Path $PSScriptRoot "ivan-core.json"
if (-not (Test-Path $packPath)) { throw "Missing $packPath" }
$pack = Get-Content $packPath -Raw | ConvertFrom-Json
$skillsCsv = $pack.install.skills_csv
$skillIds = @($skillsCsv -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })

if (-not $Path) {
  switch ($Target) {
    "agents" { $Path = Join-Path $env:USERPROFILE ".agents\skills" }
    "claude" { $Path = Join-Path $env:USERPROFILE ".claude\skills" }
    "cursor" { $Path = Join-Path (Get-Location) ".cursor\skills" }
    "codex"  { $Path = Join-Path $env:USERPROFILE ".codex\skills" }
    "hermes" {
      # Hermes bundled skills live in-repo; user/agent skills often under HERMES_HOME
      $hermesHome = if ($env:HERMES_HOME) { $env:HERMES_HOME } else { Join-Path $env:USERPROFILE ".hermes" }
      $Path = Join-Path $hermesHome "skills"
    }
    "custom" { throw "Pass -Path when -Target custom" }
  }
}

Write-Host "Pack:   $($pack.name) v$($pack.version) ($($pack.id))"
Write-Host "Skills: $($skillIds.Count)"
Write-Host "Target: $Path"
Write-Host "Why:    tailored to OpenClaw/Hermes/Windows/MCP/crypto workflow"

if (-not (Test-Path (Join-Path $Root "node_modules"))) {
  Write-Host "Running npm ci..."
  npm ci
}

# Validate skill ids exist in this checkout
$missing = @()
foreach ($id in $skillIds) {
  if (-not (Test-Path (Join-Path $Root "skills\$id"))) { $missing += $id }
}
if ($missing.Count -gt 0) {
  throw "Missing skills in catalog: $($missing -join ', ')"
}

node tools/bin/install.js --path $Path --skills $skillsCsv
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

if ($Prune -and (Test-Path $Path)) {
  $keep = [System.Collections.Generic.HashSet[string]]::new([string[]]$skillIds)
  [void]$keep.Add("docs")
  Get-ChildItem $Path -Directory | ForEach-Object {
    if (-not $keep.Contains($_.Name)) {
      Write-Host "Prune: $($_.Name)"
      Remove-Item -Recurse -Force $_.FullName
    }
  }
}

Write-Host "Done. Skills under: $Path"
Write-Host "Tip: re-run with -Prune to drop skills not in ivan-core."
