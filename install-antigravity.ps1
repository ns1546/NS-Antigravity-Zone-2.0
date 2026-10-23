<#
.SYNOPSIS
  NS Antigravity Zone 2.0 - Automated Installer & Restorer
.DESCRIPTION
  Restores and installs the complete Antigravity ecosystem:
  - Global Agent Directives & Personas
  - Custom & Builtin Skills
  - Rules, Standards & Architecture Guidelines
  - Plugins & Bundled Subagents
  - MCP Server Configurations & Schemas
#>

[CmdletBinding()]
param(
  [string]$GeminiConfigPath = "$env:USERPROFILE\.gemini\config",
  [string]$GeminiIdePath = "$env:USERPROFILE\.gemini\antigravity-ide"
)

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  🚀 NS Antigravity Zone 2.0 - System Deployment Engine" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan

$sourceRoot = $PSScriptRoot

# 1. Target Directories
Write-Host "`n[1/4] Ensuring target directories exist..." -ForegroundColor Green
$targetDirs = @(
  $GeminiConfigPath,
  "$GeminiConfigPath\agents",
  "$GeminiConfigPath\rules",
  "$GeminiConfigPath\skills",
  "$GeminiConfigPath\plugins",
  "$GeminiConfigPath\sidecars",
  "$GeminiConfigPath\projects",
  "$GeminiIdePath\builtin\skills",
  "$GeminiIdePath\mcp"
)

foreach ($dir in $targetDirs) {
  if (!(Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    Write-Host "  + Created: $dir" -ForegroundColor DarkGray
  }
}

# 2. Deploy Config, Rules, Agents & Skills
Write-Host "`n[2/4] Deploying Core Directives, Agents, Rules & Standalone Skills..." -ForegroundColor Green

$coreFiles = @("AGENTS.md", "GEMINI.md", "config.json", "mcp_config.json")
foreach ($file in $coreFiles) {
  if (Test-Path "$sourceRoot\$file") {
    Copy-Item "$sourceRoot\$file" "$GeminiConfigPath\$file" -Force
    Write-Host "  ✔ Deployed: $file" -ForegroundColor White
  }
}

$coreFolders = @("agents", "rules", "skills", "sidecars", "projects")
foreach ($folder in $coreFolders) {
  if (Test-Path "$sourceRoot\$folder") {
    robocopy "$sourceRoot\$folder" "$GeminiConfigPath\$folder" /E /XD .git /NFL /NDL /NJH /NJS | Out-Null
    $count = (Get-ChildItem -Path "$sourceRoot\$folder" -Directory -ErrorAction SilentlyContinue).Count
    Write-Host "  ✔ Synced $folder folder ($count items)" -ForegroundColor White
  }
}

# 3. Deploy Plugins
Write-Host "`n[3/4] Deploying Antigravity Plugins & Bundled Subagents..." -ForegroundColor Green
if (Test-Path "$sourceRoot\plugins") {
  robocopy "$sourceRoot\plugins" "$GeminiConfigPath\plugins" /E /XD .git /NFL /NDL /NJH /NJS | Out-Null
  $pluginList = Get-ChildItem -Path "$sourceRoot\plugins" -Directory
  foreach ($p in $pluginList) {
    Write-Host "  ✔ Plugin Active: $($p.Name)" -ForegroundColor Magenta
  }
}

# 4. Deploy Builtin Skills & MCP Schemas
Write-Host "`n[4/4] Deploying Builtin AGY System Skills & MCP Tool Schemas..." -ForegroundColor Green
if (Test-Path "$sourceRoot\builtin") {
  robocopy "$sourceRoot\builtin" "$GeminiIdePath\builtin" /E /XD .git /NFL /NDL /NJH /NJS | Out-Null
  Write-Host "  ✔ Builtin IDE skills synced" -ForegroundColor White
}
if (Test-Path "$sourceRoot\mcp") {
  robocopy "$sourceRoot\mcp" "$GeminiIdePath\mcp" /E /XD .git /NFL /NDL /NJH /NJS | Out-Null
  Write-Host "  ✔ MCP server schemas synced" -ForegroundColor White
}

Write-Host "`n============================================================" -ForegroundColor Cyan
Write-Host "  🎉 All Antigravity Zone 2.0 functions successfully deployed!" -ForegroundColor Green
Write-Host "============================================================`n" -ForegroundColor Cyan
