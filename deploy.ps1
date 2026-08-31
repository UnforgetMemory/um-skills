#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Deploy UM Skills to DSH (~/.dsh/skills/).
.DESCRIPTION
    Copies the single self-contained umbrella skill directory skills/um to the
    DSH skills directory at ~/.dsh/skills/. It embeds the entry router,
    profession route tables, references/ and adapters/ - one directory is the
    whole distribution (ADR-003).
    Interactive confirmation (D3 gate) is required when replacing an existing
    deployment; non-interactive runs abort safely.
#>

$ErrorActionPreference = 'Stop'

$src = Join-Path $PSScriptRoot 'skills\um'
$dst = "$env:USERPROFILE\.dsh\skills"

Write-Host "Deploying UM Skills from $src to $dst" -ForegroundColor Cyan

if (-not (Test-Path "$src\SKILL.md")) {
    Write-Error "Source skill not found: $src"
    exit 1
}

if (-not (Test-Path $dst)) {
    New-Item -ItemType Directory -Path $dst -Force | Out-Null
    Write-Host "Created $dst" -ForegroundColor Yellow
}

# Legacy layout hint (v0.1.x deployed shared core/, adapters/ and four skill dirs).
# Hint only - never delete without explicit user action.
$legacyPaths = @('core', 'adapters', 'umpp', 'umcommit', 'umrelease', 'umreview')
foreach ($legacy in $legacyPaths) {
    if (Test-Path "$dst\$legacy") {
        Write-Host "NOTE: legacy '$dst\$legacy' detected (v0.1.x layout). It is no longer used and can be deleted manually." -ForegroundColor Yellow
    }
}

$target = "$dst\um"
Write-Host "  Copying um -> $target" -ForegroundColor Gray
# D3 gate (destructive-ops-gates.md): confirm before replacing an existing deployment
# Rename instead of delete so the previous deployment remains a recovery point
if (Test-Path $target) {
    Write-Host "  Gate D3: existing deployment at '$target' will be replaced (old kept as backup)." -ForegroundColor Yellow
    $confirm = Read-Host "  Remove and re-copy? [y/N]"
    if ($confirm -notmatch '^[yY]') {
        Write-Host "  Aborted by user. No changes made." -ForegroundColor Red
        exit 1
    }
    $backup = "$target.bak"
    if (Test-Path $backup) {
        Write-Host "  Aborted: previous recovery point '$backup' exists. Restore or remove it manually first." -ForegroundColor Red
        exit 1
    }
    Rename-Item -Path $target -NewName (Split-Path $backup -Leaf)
    Write-Host "  Recovery point: $backup" -ForegroundColor Yellow
}
Copy-Item -Path $src -Destination $dst -Recurse -Force

Write-Host ""
Write-Host "Deployment complete!" -ForegroundColor Green
Write-Host "Skill deployed to: $target" -ForegroundColor Cyan
Write-Host ""
Write-Host "NOTE: Reload DSH skills or restart DSH process for changes to take effect." -ForegroundColor Yellow
