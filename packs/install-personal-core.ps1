# Legacy entrypoint — installs Ivan Core (tailored pack).
param(
  [ValidateSet("grok", "agents", "all", "custom")]
  [string]$Target = "grok",
  [string]$Path = "",
  [switch]$Prune
)
& "$PSScriptRoot\install-ivan-core.ps1" -Target $Target -Path $Path -Prune:$Prune
