# run-agent-interactive.ps1
# Run cursor-agent interactively in the Docker container

Write-Host "Starting cursor-agent in interactive mode..." -ForegroundColor Cyan
Write-Host ""

# Check if container is running
$containerRunning = docker ps --filter name=cursor-agent --format "{{.Names}}" | Select-String -Pattern "cursor-agent"

if (-not $containerRunning) {
    Write-Host "Container is not running. Starting it..." -ForegroundColor Yellow
    docker compose up -d
    Start-Sleep -Seconds 3
}

Write-Host "Entering container to run cursor-agent interactively..." -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the agent" -ForegroundColor Yellow
Write-Host ""

# Run cursor-agent interactively in the container
docker exec -it cursor-agent cursor-agent

