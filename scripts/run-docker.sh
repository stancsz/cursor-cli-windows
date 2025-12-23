#!/usr/bin/env bash
# run-docker.sh
# macOS/Linux helper script to build and start the Cursor agent container

set -euo pipefail

echo "Checking Docker installation..."

# Check if Docker is installed
if command -v docker >/dev/null 2>&1; then
    DOCKER_VERSION=$(docker --version)
    echo "✓ Docker found: $DOCKER_VERSION"
else
    echo "✗ Docker is not installed or not in PATH"
    echo "Please install Docker Desktop or Docker Engine"
    exit 1
fi

# Check if Docker Compose is available
if docker compose version >/dev/null 2>&1; then
    COMPOSE_VERSION=$(docker compose version)
    echo "✓ Docker Compose found: $COMPOSE_VERSION"
else
    echo "✗ Docker Compose is not available"
    exit 1
fi

# Check if Docker daemon is running
if docker info >/dev/null 2>&1; then
    echo "✓ Docker daemon is running"
else
    echo "✗ Docker daemon is not running"
    echo "Please start Docker and wait until it's ready"
    exit 1
fi

echo ""
echo "Building and starting the Cursor agent container..."
echo ""

# Build and start the container
docker compose up --build -d

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Container started successfully!"
    echo ""
    echo "Next steps:"
    echo "  1. Enter the container: docker exec -it cursor-agent bash"
    echo "  2. Check agent logs: docker exec cursor-agent tail -n 20 /workspace/cursor-agent.log"
    echo "  3. View container status: docker ps"
else
    echo ""
    echo "✗ Failed to start container"
    exit 1
fi

