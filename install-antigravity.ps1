<#
.SYNOPSIS
  NS Antigravity Zone 2.0 - Automated Installer & System Restorer
.DESCRIPTION
  Restores and installs the complete Antigravity ecosystem:
  - 116 High-Performance Engineering Skills
  - 30 Custom Autonomous Specialist Subagents
  - 3 Core Engineering & Architecture Rules
  - 9 Production Tool & Feature Plugins
  - Native MCP Server Schemas & Builtin AGY Runtime Guidance
#>

[CmdletBinding()]
param(
  [string]$GeminiConfigPath = "$env:USERPROFILE\.gemini\config",
  [string]$GeminiIdePath = "$env:USERPROFILE\.gemini\antigravity-ide"
)

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  🚀 NS Antigravity Zone 2.0 - System Deployment Engine" -ForegroundColor Yellow
Write-Host "  Skills: 116 | Agents: 30 | Rules: 3 | Plugins: 9" -ForegroundColor Green
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
Write-Host "`n[2/4] Deploying Core Directives, 30 Custom Agents, 3 Rules & 116 Skills..." -ForegroundColor Green

$coreFiles = @("AGENTS.md", "GEMINI.md", "config.json", "mcp_config.json")
foreach ($file in $coreFiles) {
  if (Test-Path "$sourceRoot\$file") {
    Copy-Item "$sourceRoot\$file" "$GeminiConfigPath\$file" -Force
    Write-Host "  ✔ Deployed: $file" -ForegroundColor White
  }
}

# Deploy 30 Agents
robocopy "$sourceRoot\agents" "$GeminiConfigPath\agents" /E /XD .git /NFL /NDL /NJH /NJS | Out-Null
$agentCount = (Get-ChildItem -Path "$sourceRoot\agents" -Filter "*.md").Count
Write-Host "  ✔ Synced $agentCount Custom Agents" -ForegroundColor Cyan

# Deploy 3 Rules
robocopy "$sourceRoot\rules" "$GeminiConfigPath\rules" /E /XD .git /NFL /NDL /NJH /NJS | Out-Null
$ruleCount = (Get-ChildItem -Path "$sourceRoot\rules" -Filter "*.md").Count
Write-Host "  ✔ Synced $ruleCount Core Rules" -ForegroundColor Cyan

# Deploy 116 Skills
robocopy "$sourceRoot\skills" "$GeminiConfigPath\skills" /E /XD .git /NFL /NDL /NJH /NJS | Out-Null
$skillCount = (Get-ChildItem -Path "$sourceRoot\skills" -Directory).Count
Write-Host "  ✔ Synced $skillCount Engineering Skills" -ForegroundColor Cyan

# 3. Deploy 9 Plugins
Write-Host "`n[3/4] Deploying 9 Production Plugins..." -ForegroundColor Green
robocopy "$sourceRoot\plugins" "$GeminiConfigPath\plugins" /E /XD .git /NFL /NDL /NJH /NJS | Out-Null
$pluginList = Get-ChildItem -Path "$sourceRoot\plugins" -Directory
foreach ($p in $pluginList) {
  Write-Host "  ✔ Plugin Active: $($p.Name)" -ForegroundColor Magenta
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
Write-Host "  🎉 All 116 Skills, 30 Agents, 3 Rules & 9 Plugins Successfully Deployed!" -ForegroundColor Green
Write-Host "============================================================`n" -ForegroundColor Cyan
