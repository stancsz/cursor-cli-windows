#!/usr/bin/env bash
# run-agent-interactive.sh
# Run cursor-agent interactively in the Docker container

set -euo pipefail

echo "Starting cursor-agent in interactive mode..."
echo ""

# Check if container is running
if ! docker ps --filter name=cursor-agent --format "{{.Names}}" | grep -q cursor-agent; then
    echo "Container is not running. Starting it..."
    docker compose up -d
    sleep 3
fi

echo "Entering container to run cursor-agent interactively..."
echo "Press Ctrl+C to stop the agent"
echo ""

# Run cursor-agent interactively in the container
docker exec -it cursor-agent cursor-agent

