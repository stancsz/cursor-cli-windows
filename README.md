# Cursor CLI Docker Setup

This repository contains a Docker setup for running the Cursor CLI agent in a containerized environment.

## Quick Start

### Prerequisites

- Docker Desktop (Windows) or Docker Engine (macOS/Linux)
- Docker Compose

### Setup Steps

1. **Create environment file** (optional but recommended):
   ```bash
   # Copy the example and add your Cursor credentials
   cp .env.example .env
   # Edit .env and add your CURSOR_API_KEY
   ```

2. **Build and start the container**:
   
   **Windows (PowerShell):**
   ```powershell
   .\run-docker.ps1
   ```
   
   **macOS/Linux:**
   ```bash
   chmod +x run-docker.sh
   ./run-docker.sh
   ```
   
   **Or manually:**
   ```bash
   docker compose up --build -d
   ```

3. **Enter the container**:
   ```bash
   docker exec -it cursor-agent bash
   ```

4. **Check agent logs**:
   ```bash
   docker exec cursor-agent tail -n 20 /workspace/cursor-agent.log
   ```

## Configuration

### Environment Variables

Create a `.env` file in the repository root with your Cursor credentials:

```bash
CURSOR_API_KEY=your_cursor_api_key_here
```

### Volumes

- The entire repository root is mounted at `/workspace` in the container
- The `sandbox/` directory is also explicitly mounted for shared files with Cursor

## Docker Compose Commands

- **Start container**: `docker compose up -d`
- **Stop container**: `docker compose down`
- **View logs**: `docker compose logs -f cursor-agent`
- **Rebuild**: `docker compose up --build -d`
- **Enter container**: `docker exec -it cursor-agent bash`

## Troubleshooting

### Docker not found
- Install Docker Desktop from: https://docs.docker.com/desktop/install/windows/
- Ensure Docker is running before executing commands

### Cursor CLI not installed
If the CLI installation fails during build, you can install it manually:
```bash
docker exec -it cursor-agent bash
curl https://cursor.com/install -fsS | bash
```

### Authentication issues
- Verify your `CURSOR_API_KEY` in the `.env` file
- Check the container logs: `docker compose logs cursor-agent`

## File Structure

```
.
├── docker-compose.yml      # Docker Compose configuration
├── Dockerfile              # Container image definition
├── docker-entrypoint.sh    # Container entrypoint script
├── run-docker.ps1          # Windows helper script
├── run-docker.sh           # macOS/Linux helper script
├── .env                    # Environment variables (gitignored)
├── sandbox/                # Shared directory with Cursor
└── README.md               # This file
```

## Notes

- The container runs `cursor-agent` automatically on startup if the CLI is installed
- Logs are written to `/workspace/cursor-agent.log` inside the container
- The container stays alive with `tail -f /dev/null` so you can exec into it
- Set `INSTALL_CURSOR=false` in docker-compose.yml to skip CLI installation during build
