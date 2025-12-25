#!/usr/bin/env bash
# cursor.sh
# Wrapper script to run cursor-agent interactively (Linux/macOS)
# Usage: cursor [workspace-path]
#   If workspace-path is provided, that directory will be used as workspace
#   If no path provided, uses current directory (.)

set -euo pipefail

WORKSPACE_PATH="${1:-.}"

# Get the script directory (where this script is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Path to the actual run-agent-interactive script
RUN_SCRIPT="$SCRIPT_DIR/run-agent-interactive.sh"

# Resolve the workspace path
if [ "$WORKSPACE_PATH" = "." ] || [ -z "$WORKSPACE_PATH" ]; then
    WORKSPACE_PATH="$(pwd)"
elif [ ! -d "$WORKSPACE_PATH" ]; then
    # Relative path - resolve relative to current directory
    WORKSPACE_PATH="$(cd "$WORKSPACE_PATH" && pwd)"
fi

# Call the actual script
exec "$RUN_SCRIPT" "$WORKSPACE_PATH"

