#!/usr/bin/env bash

set -euo pipefail
export PATH="/root/.local/bin:$PATH"

# docker-entrypoint-interactive.sh
# This version does NOT auto-start cursor-agent in the background.
# Use this if you want to run cursor-agent manually/interactively.
#
# To use this, override the entrypoint in docker-compose.yml or use:
# docker compose run --entrypoint /usr/local/bin/docker-entrypoint-interactive.sh cursor-agent

# Load .env from the mounted repository if it exists
if [ -f /workspace/.env ]; then
  echo "Sourcing /workspace/.env"
  # Export all variables defined in .env
  set -o allexport
  # shellcheck disable=SC1090
  . /workspace/.env
  set +o allexport
else
  echo "/workspace/.env not found; skipping env load"
fi

# Provide some diagnostic info
echo "Working directory: $(pwd)"
echo "Environment summary:"
env | sort

# If cursor CLI is available, attempt non-interactive setup using CURSOR_API_KEY
if command -v cursor >/dev/null 2>&1; then
  echo "cursor CLI detected."
  if [ -n "${CURSOR_API_KEY:-}" ]; then
    echo "Attempting non-interactive config using CURSOR_API_KEY..."
    # Example of a generic set command; may need adjustment for actual cursor CLI
    if cursor config set api_key "$CURSOR_API_KEY" >/dev/null 2>&1; then
      echo "cursor CLI configured with CURSOR_API_KEY."
    else
      echo "cursor CLI config with CURSOR_API_KEY failed. Check key and CLI commands."
    fi
  else
    echo "No CURSOR_API_KEY found in environment; skipping automatic auth."
  fi
else
  echo "cursor CLI not installed in image. To enable automatic setup, install the CLI in the Dockerfile or run installer inside the container:"
  echo "  docker exec -it cursor-agent bash"
  echo "  curl https://cursor.com/install -fsS | bash"
fi

# Note: cursor-agent is NOT auto-started in this version
# Run it manually: cursor-agent
echo ""
echo "cursor-agent is available but not auto-started."
echo "Run it manually with: cursor-agent"
echo "Or run it interactively: docker exec -it cursor-agent cursor-agent"

# Execute the container command (usually to keep container alive)
exec "$@"

