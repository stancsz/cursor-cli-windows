# setup-cursor-command.ps1
# Setup script to add cursor command to PATH
# Run this script as Administrator or it will add to user PATH

param(
    [switch]$UserPath = $true,
    [switch]$SystemPath = $false
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir

Write-Host "Setting up cursor-win command..." -ForegroundColor Cyan
Write-Host ""

# Determine which PATH to modify
if ($SystemPath) {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Error: System PATH modification requires Administrator privileges." -ForegroundColor Red
        Write-Host "Please run this script as Administrator, or use -UserPath (default)." -ForegroundColor Yellow
        exit 1
    }
    $PathScope = [EnvironmentVariableTarget]::Machine
    $PathName = "System PATH"
} else {
    $PathScope = [EnvironmentVariableTarget]::User
    $PathName = "User PATH"
}

# Get current PATH
$CurrentPath = [Environment]::GetEnvironmentVariable("Path", $PathScope)

# Handle null or empty PATH
if ([string]::IsNullOrEmpty($CurrentPath)) {
    $CurrentPath = ""
}

# Check if already in PATH
if ($CurrentPath -split ';' | Where-Object { $_ -eq $ScriptDir }) {
    Write-Host "✓ Scripts directory is already in $PathName" -ForegroundColor Green
} else {
    # Add to PATH - only add semicolon if CurrentPath is not empty
    if ([string]::IsNullOrEmpty($CurrentPath)) {
        $NewPath = $ScriptDir
    } else {
        $NewPath = $CurrentPath + ";" + $ScriptDir
    }
    [Environment]::SetEnvironmentVariable("Path", $NewPath, $PathScope)
    Write-Host "✓ Added scripts directory to $PathName" -ForegroundColor Green
    Write-Host "  Location: $ScriptDir" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Note: You may need to restart your terminal for changes to take effect." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Setup complete! You can now use:" -ForegroundColor Green
Write-Host "  cursor-win                    # Run in current directory" -ForegroundColor Cyan
Write-Host "  cursor-win .                   # Run in current directory" -ForegroundColor Cyan
Write-Host "  cursor-win C:\path\to\project # Run in specified directory" -ForegroundColor Cyan
Write-Host ""

