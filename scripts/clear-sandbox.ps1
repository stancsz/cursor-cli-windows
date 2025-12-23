# clear-sandbox.ps1
# Script to clear the sandbox workspace (preserves README.md and .gitkeep)

param(
    [switch]$Force  # Skip confirmation prompt
)

$sandboxPath = Join-Path $PSScriptRoot "..\sandbox"

if (-not (Test-Path $sandboxPath)) {
    Write-Host "Sandbox directory not found: $sandboxPath" -ForegroundColor Red
    exit 1
}

Write-Host "Sandbox Clear Script" -ForegroundColor Cyan
Write-Host "===================" -ForegroundColor Cyan
Write-Host ""

# Get all items except README.md and .gitkeep
$itemsToDelete = Get-ChildItem -Path $sandboxPath -Exclude "README.md", ".gitkeep" -Force

if ($itemsToDelete.Count -eq 0) {
    Write-Host "Sandbox is already empty (only README.md and .gitkeep exist)" -ForegroundColor Yellow
    exit 0
}

Write-Host "Files and directories to be deleted:" -ForegroundColor Yellow
foreach ($item in $itemsToDelete) {
    $type = if ($item.PSIsContainer) { "Directory" } else { "File" }
    Write-Host "  [$type] $($item.Name)" -ForegroundColor White
}
Write-Host ""
Write-Host "README.md and .gitkeep will be preserved" -ForegroundColor Green
Write-Host ""

if (-not $Force) {
    $confirmation = Read-Host "Are you sure you want to delete these items? (y/N)"
    if ($confirmation -ne "y" -and $confirmation -ne "Y") {
        Write-Host "Operation cancelled" -ForegroundColor Yellow
        exit 0
    }
}

Write-Host ""
Write-Host "Clearing sandbox..." -ForegroundColor Cyan

# Delete all items except README.md
$deletedCount = 0
foreach ($item in $itemsToDelete) {
    try {
        if ($item.PSIsContainer) {
            Remove-Item -Path $item.FullName -Recurse -Force
        } else {
            Remove-Item -Path $item.FullName -Force
        }
        $deletedCount++
        Write-Host "  Deleted: $($item.Name)" -ForegroundColor Gray
    } catch {
        Write-Host "  Failed to delete: $($item.Name) - $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Sandbox cleared successfully! ($deletedCount item(s) deleted)" -ForegroundColor Green
Write-Host "README.md and .gitkeep preserved" -ForegroundColor Green

