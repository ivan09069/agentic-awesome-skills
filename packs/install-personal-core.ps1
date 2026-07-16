# Legacy entrypoint — installs Ivan Core (tailored pack).
param(
  [ValidateSet("agents", "claude", "cursor", "codex", "hermes", "custom")]
  [string]$Target = "agents",
  [string]$Path = "",
  [switch]$Prune
)
& "$PSScriptRoot\install-ivan-core.ps1" -Target $Target -Path $Path -Prune:$Prune
