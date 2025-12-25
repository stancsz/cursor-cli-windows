#!/usr/bin/env bash
# run-agent-interactive.sh
# Run cursor-agent interactively in the Docker container
# Usage: ./run-agent-interactive.sh [workspace-path]
#   If workspace-path is provided, that directory will be mounted as /workspace
#   Otherwise, defaults to ./sandbox

set -euo pipefail

# Get the script directory (where docker-compose.yml is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

WORKSPACE_PATH="${1:-}"

echo "Starting cursor-agent in interactive mode..."
echo ""

# Determine workspace path
if [ -n "$WORKSPACE_PATH" ]; then
    # Custom path provided - convert to absolute path
    if [ ! -d "$WORKSPACE_PATH" ]; then
        echo "Error: Path does not exist: $WORKSPACE_PATH" >&2
        exit 1
    fi
    
    WORKSPACE_PATH="$(cd "$WORKSPACE_PATH" && pwd)"
    echo "Using custom workspace: $WORKSPACE_PATH"
    
    # Stop any existing cursor-agent container (from docker-compose)
    if docker ps -a --filter name=cursor-agent --format "{{.Names}}" | grep -q cursor-agent; then
        echo "Stopping existing cursor-agent container..."
        docker stop cursor-agent 2>/dev/null || true
        docker rm cursor-agent 2>/dev/null || true
    fi
    
    # Ensure image is built
    cd "$REPO_ROOT"
    IMAGE_NAME=$(docker compose config --images 2>/dev/null | grep cursor-agent | tr -d ' ' || echo "")
    if [ -z "$IMAGE_NAME" ]; then
        echo "Building Docker image..."
        docker compose build >/dev/null
        IMAGE_NAME=$(docker compose config --images | grep cursor-agent | tr -d ' ')
    fi
    
    # Get .env file path from repo root
    ENV_FILE="$REPO_ROOT/.env"
    ENV_FILE_ARGS=()
    ENV_VOLUME_ARGS=()
    if [ -f "$ENV_FILE" ]; then
        # Mount repo's .env file to a fixed location in container
        ENV_VOLUME_ARGS=("-v" "${ENV_FILE}:/repo/.env:ro")
        ENV_FILE_ARGS=("--env-file" "$ENV_FILE")
    fi
    
    echo "Starting container with custom workspace..."
    echo "Press Ctrl+C to stop the agent"
    echo ""
    
    # Run docker run with custom volume mount, using interactive entrypoint
    docker run --rm -it \
        --name cursor-agent \
        --workdir /workspace \
        "${ENV_FILE_ARGS[@]}" \
        "${ENV_VOLUME_ARGS[@]}" \
        -v "${WORKSPACE_PATH}:/workspace:rw" \
        --entrypoint /usr/local/bin/docker-entrypoint-interactive.sh \
        "$IMAGE_NAME" \
        cursor-agent
else
    # Default: use docker-compose with sandbox
    echo "Using default workspace: sandbox/"
    
    # Check if container is running
    if ! docker ps --filter name=cursor-agent --format "{{.Names}}" | grep -q cursor-agent; then
        echo "Container is not running. Starting it..."
        cd "$REPO_ROOT"
        docker compose up -d
        sleep 3
    fi
    
    echo "Entering container to run cursor-agent interactively..."
    echo "Press Ctrl+C to stop the agent"
    echo ""
    
    # Run cursor-agent interactively in the container
    docker exec -it cursor-agent cursor-agent
fi

