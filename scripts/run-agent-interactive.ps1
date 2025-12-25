# run-agent-interactive.ps1
# Run cursor-agent interactively in the Docker container
# Usage: .\run-agent-interactive.ps1 [workspace-path]
#   If workspace-path is provided, that directory will be mounted as /workspace
#   Otherwise, defaults to ./sandbox

param(
    [Parameter(Position=0)]
    [string]$WorkspacePath = ""
)

# Get the script directory (where docker-compose.yml is located)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir

Write-Host "Starting cursor-agent in interactive mode..." -ForegroundColor Cyan
Write-Host ""

# Determine workspace path
if ($WorkspacePath) {
    # Custom path provided - convert to absolute path
    if (-not [System.IO.Path]::IsPathRooted($WorkspacePath)) {
        $WorkspacePath = Resolve-Path $WorkspacePath -ErrorAction Stop
    } else {
        $WorkspacePath = [System.IO.Path]::GetFullPath($WorkspacePath)
    }
    
    if (-not (Test-Path $WorkspacePath -PathType Container)) {
        Write-Host "Error: Path does not exist: $WorkspacePath" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "Using custom workspace: $WorkspacePath" -ForegroundColor Yellow
    
    # Stop any existing cursor-agent container (from docker-compose)
    $existingContainer = docker ps -a --filter name=cursor-agent --format "{{.Names}}" | Select-String -Pattern "cursor-agent"
    if ($existingContainer) {
        Write-Host "Stopping existing cursor-agent container..." -ForegroundColor Yellow
        docker stop cursor-agent 2>$null | Out-Null
        docker rm cursor-agent 2>$null | Out-Null
    }
    
    # Ensure image is built
    Push-Location $RepoRoot
    $imageName = docker compose config --images 2>$null | Select-String -Pattern "cursor-agent" | ForEach-Object { $_.Line.Trim() }
    if (-not $imageName) {
        Write-Host "Building Docker image..." -ForegroundColor Yellow
        docker compose build | Out-Null
        $imageName = docker compose config --images | Select-String -Pattern "cursor-agent" | ForEach-Object { $_.Line.Trim() }
    }
    Pop-Location
    
    # Get .env file path from repo root
    $envFile = Join-Path $RepoRoot ".env"
    $envFileArgs = @()
    $envVolumeArgs = @()
    if (Test-Path $envFile) {
        # Mount repo's .env file to a fixed location in container
        $envVolumeArgs = @("-v", "${envFile}:/repo/.env:ro")
        $envFileArgs = @("--env-file", $envFile)
    }
    
    Write-Host "Starting container with custom workspace..." -ForegroundColor Green
    Write-Host "Press Ctrl+C to stop the agent" -ForegroundColor Yellow
    Write-Host ""
    
    # Run docker run with custom volume mount, using interactive entrypoint
    # The entrypoint will set up the environment, then we override command to run cursor-agent
    $dockerArgs = @(
        "run", "--rm", "-it",
        "--name", "cursor-agent",
        "--workdir", "/workspace"
    )
    $dockerArgs += $envFileArgs
    $dockerArgs += $envVolumeArgs
    $dockerArgs += @(
        "-v", "${WorkspacePath}:/workspace:rw",
        "--entrypoint", "/usr/local/bin/docker-entrypoint-interactive.sh",
        $imageName,
        "cursor-agent"
    )
    
    & docker $dockerArgs
} else {
    # Default: use docker-compose with sandbox
    Write-Host "Using default workspace: sandbox/" -ForegroundColor Yellow
    
    # Check if container is running
    $containerRunning = docker ps --filter name=cursor-agent --format "{{.Names}}" | Select-String -Pattern "cursor-agent"
    
    if (-not $containerRunning) {
        Write-Host "Container is not running. Starting it..." -ForegroundColor Yellow
        Push-Location $RepoRoot
        docker compose up -d
        Pop-Location
        Start-Sleep -Seconds 3
    }
    
    Write-Host "Entering container to run cursor-agent interactively..." -ForegroundColor Green
    Write-Host "Press Ctrl+C to stop the agent" -ForegroundColor Yellow
    Write-Host ""
    
    # Run cursor-agent interactively in the container
    docker exec -it cursor-agent cursor-agent
}

