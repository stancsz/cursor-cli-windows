#!/usr/bin/env bash
# clear-sandbox.sh
# Script to clear the sandbox workspace (preserves README.md and .gitkeep)

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SANDBOX_PATH="$SCRIPT_DIR/../sandbox"

if [ ! -d "$SANDBOX_PATH" ]; then
    echo "✗ Sandbox directory not found: $SANDBOX_PATH" >&2
    exit 1
fi

echo "Sandbox Clear Script"
echo "==================="
echo ""

# Count items to delete (excluding README.md and .gitkeep)
ITEMS_TO_DELETE=()
while IFS= read -r -d '' item; do
    BASENAME=$(basename "$item")
    if [ "$BASENAME" != "README.md" ] && [ "$BASENAME" != ".gitkeep" ]; then
        ITEMS_TO_DELETE+=("$item")
    fi
done < <(find "$SANDBOX_PATH" -mindepth 1 -maxdepth 1 -print0 2>/dev/null || true)

if [ ${#ITEMS_TO_DELETE[@]} -eq 0 ]; then
    echo "✓ Sandbox is already empty (only README.md and .gitkeep exist)"
    exit 0
fi

echo "Files and directories to be deleted:"
for item in "${ITEMS_TO_DELETE[@]}"; do
    if [ -d "$item" ]; then
        echo "  [Directory] $(basename "$item")"
    else
        echo "  [File] $(basename "$item")"
    fi
done
echo ""
echo "✓ README.md and .gitkeep will be preserved"
echo ""

# Check for --force flag
FORCE=false
if [ "${1:-}" = "--force" ] || [ "${1:-}" = "-f" ]; then
    FORCE=true
fi

if [ "$FORCE" = false ]; then
    read -p "Are you sure you want to delete these items? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Operation cancelled"
        exit 0
    fi
fi

echo ""
echo "Clearing sandbox..."

DELETED_COUNT=0
for item in "${ITEMS_TO_DELETE[@]}"; do
    if rm -rf "$item" 2>/dev/null; then
        echo "  Deleted: $(basename "$item")"
        ((DELETED_COUNT++)) || true
    else
        echo "  ✗ Failed to delete: $(basename "$item")" >&2
    fi
done

echo ""
echo "✓ Sandbox cleared successfully! ($DELETED_COUNT item(s) deleted)"
echo "✓ README.md and .gitkeep preserved"

