# Install the Personal Core skill pack into a local agent skills directory.
param(
  [ValidateSet("agents", "claude", "cursor", "codex", "custom")]
  [string]$Target = "agents",
  [string]$Path = ""
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
if (-not $Root) { $Root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path }
Set-Location $Root

$packPath = Join-Path $PSScriptRoot "personal-core.json"
if (-not (Test-Path $packPath)) { throw "Missing $packPath" }
$pack = Get-Content $packPath -Raw | ConvertFrom-Json
$skillsCsv = $pack.install.skills_csv
if (-not $skillsCsv) { throw "pack.install.skills_csv is empty" }

if (-not $Path) {
  switch ($Target) {
    "agents" { $Path = Join-Path $env:USERPROFILE ".agents\skills" }
    "claude" { $Path = Join-Path $env:USERPROFILE ".claude\skills" }
    "cursor" { $Path = Join-Path (Get-Location) ".cursor\skills" }
    "codex"  { $Path = Join-Path $env:USERPROFILE ".codex\skills" }
    "custom" { throw "Pass -Path when -Target custom" }
  }
}

Write-Host "Pack:   $($pack.name) ($($pack.id))"
Write-Host "Skills: $($skillsCsv.Split(',').Count)"
Write-Host "Target: $Path"

if (-not (Test-Path (Join-Path $Root "node_modules"))) {
  Write-Host "Running npm ci..."
  npm ci
}

node tools/bin/install.js --path $Path --skills $skillsCsv
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host "Done. Skills installed under: $Path"
