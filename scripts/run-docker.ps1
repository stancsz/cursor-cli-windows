# run-docker.ps1
# Windows PowerShell helper script to build and start the Cursor agent container

Write-Host "Checking Docker installation..." -ForegroundColor Cyan

# Check if Docker is installed
try {
    $dockerVersion = docker --version 2>&1
    Write-Host "Docker found: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "Docker is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Docker Desktop from: https://docs.docker.com/desktop/install/windows/" -ForegroundColor Yellow
    exit 1
}

# Check if Docker Compose is available
try {
    $composeVersion = docker compose version 2>&1
    Write-Host "Docker Compose found: $composeVersion" -ForegroundColor Green
} catch {
    Write-Host "Docker Compose is not available" -ForegroundColor Red
    exit 1
}

# Check if Docker daemon is running
try {
    docker info | Out-Null
    Write-Host "Docker daemon is running" -ForegroundColor Green
} catch {
    Write-Host "Docker daemon is not running" -ForegroundColor Red
    Write-Host "Please start Docker Desktop and wait until it is ready" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Building and starting the Cursor agent container..." -ForegroundColor Cyan
Write-Host ""

# Build and start the container
docker compose up --build -d

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Container started successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Enter the container: docker exec -it cursor-agent bash" -ForegroundColor White
    Write-Host "  2. Check agent logs: docker exec cursor-agent tail -n 20 /workspace/cursor-agent.log" -ForegroundColor White
    Write-Host "  3. View container status: docker ps" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "Failed to start container" -ForegroundColor Red
    exit 1
}
