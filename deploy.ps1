#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Deploy UM Skills to DSH (~/.dsh/skills/).
.DESCRIPTION
    Copies the UM Skills project files (core/, adapters/, umpp/, umcommit/,
    umrelease/, umreview/) to the DSH skills directory at ~/.dsh/skills/.
#>

$ErrorActionPreference = 'Stop'

$src = $PSScriptRoot
$dst = "$env:USERPROFILE\.dsh\skills"

Write-Host "Deploying UM Skills from $src to $dst" -ForegroundColor Cyan

# Validate source directories
$dirs = @('core', 'adapters', 'umpp', 'umcommit', 'umrelease', 'umreview')
foreach ($d in $dirs) {
    if (-not (Test-Path "$src\$d")) {
        Write-Error "Source directory not found: $src\$d"
        exit 1
    }
}

# Ensure destination exists
if (-not (Test-Path $dst)) {
    New-Item -ItemType Directory -Path $dst -Force | Out-Null
    Write-Host "Created $dst" -ForegroundColor Yellow
}

# Copy each directory
foreach ($d in $dirs) {
    $target = "$dst\$d"
    Write-Host "  Copying $d -> $target" -ForegroundColor Gray
    if (Test-Path $target) {
        Remove-Item -Path $target -Recurse -Force
    }
    Copy-Item -Path "$src\$d" -Destination $dst -Recurse -Force
}

Write-Host ""
Write-Host "Deployment complete!" -ForegroundColor Green
Write-Host "Skills deployed to: $dst" -ForegroundColor Cyan
Write-Host "Skill directories:" -ForegroundColor Cyan
Get-ChildItem -Path $dst -Directory | ForEach-Object { "  - $($_.Name)" }
Write-Host ""
Write-Host "NOTE: Reload DSH skills or restart DSH process for changes to take effect." -ForegroundColor Yellow