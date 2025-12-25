# cursor-win.ps1
# Wrapper script to run cursor-agent interactively (Windows)
# Usage: cursor-win [workspace-path]
#   If workspace-path is provided, that directory will be used as workspace
#   If no path provided, uses current directory (.)
#   If path is ".", uses current directory

param(
    [Parameter(Position=0)]
    [string]$WorkspacePath = "."
)

# Get the script directory (where this script is located)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Get the repo root (parent of scripts directory)
$RepoRoot = Split-Path -Parent $ScriptDir

# Path to the actual run-agent-interactive script
$RunScript = Join-Path $ScriptDir "run-agent-interactive.ps1"

# Resolve the workspace path
if ($WorkspacePath -eq "." -or $WorkspacePath -eq "") {
    $WorkspacePath = (Get-Location).Path
} elseif (-not [System.IO.Path]::IsPathRooted($WorkspacePath)) {
    # Relative path - resolve relative to current directory
    $WorkspacePath = (Resolve-Path $WorkspacePath -ErrorAction Stop).Path
}

# Call the actual script
& $RunScript -WorkspacePath $WorkspacePath

