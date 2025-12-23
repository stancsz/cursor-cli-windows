# Sandbox Directory

This directory is shared with the Cursor agent container.

Files placed here will be accessible at `/workspace/sandbox` inside the container.

## Usage

1. Place files in this directory
2. Access them from the container:
   ```bash
   docker exec -it cursor-agent bash
   ls -la /workspace/sandbox
   ```

