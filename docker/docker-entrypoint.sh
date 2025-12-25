#!/usr/bin/env bash

set -euo pipefail
export PATH="/root/.local/bin:$PATH"

# docker-entrypoint.sh
# - Sources /workspace/.env if present
# - Attempts a non-interactive cursor CLI config if cursor is installed and CURSOR_API_KEY is set
# - Falls back to keeping the container running and prints helpful messages
#
# Usage: This script is intended to be used as the container ENTRYPOINT.
# The Dockerfile should make it executable and set CMD to keep the container alive, e.g.:
#   ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
#   CMD ["tail", "-f", "/dev/null"]

# Load .env from the repo root (mounted at /repo/.env) if it exists
# This ensures we use the repo's .env file, not the workspace's .env
if [ -f /repo/.env ]; then
  echo "Sourcing /repo/.env (repo configuration)"
  # Strip CR characters (handle Windows CRLF line endings) and source
  # Export all variables defined in .env
  set -o allexport
  # shellcheck disable=SC1090
  # Use process substitution to strip CR characters before sourcing
  . <(tr -d '\r' < /repo/.env)
  set +o allexport
elif [ -f /workspace/.env ]; then
  # Fallback: if repo .env not found, try workspace .env (for docker-compose mode)
  echo "Sourcing /workspace/.env (workspace configuration)"
  set -o allexport
  # shellcheck disable=SC1090
  . <(tr -d '\r' < /workspace/.env)
  set +o allexport
else
  echo ".env not found; skipping env load (using --env-file if provided)"
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

# Start cursor-agent if the CLI is available
if command -v cursor-agent >/dev/null 2>&1; then
  AGENT_LOG="/workspace/cursor-agent.log"
  echo "Starting cursor-agent service (log: $AGENT_LOG)..."
  cursor-agent >>"$AGENT_LOG" 2>&1 &
else
  echo "cursor-agent binary not found; skipping automatic service startup."
fi

# Execute the container command (usually to keep container alive)
exec "$@"

