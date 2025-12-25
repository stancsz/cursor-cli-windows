# Cursor CLI Docker Setup

A containerized development environment for running the Cursor CLI agent with Docker. This project provides a complete setup for running Cursor's AI-powered coding assistant in an isolated, reproducible container environment.

## Overview

This repository provides a Docker-based solution for running the Cursor CLI agent, making it easy to:
- Run Cursor agent in a consistent, isolated environment
- Share workspace files between host and container
- Manage agent configuration and authentication
- Run the agent in background or interactive modes

## Features

- 🐳 **Docker-based**: Fully containerized setup using Docker Compose
- 🔐 **Secure Configuration**: Environment-based API key management
- 📁 **Volume Mounting**: Full workspace access with shared sandbox directory
- 🚀 **Quick Start**: Helper scripts for Windows, macOS, and Linux
- 📊 **Logging**: Automatic log file generation for background operations
- 🔄 **Interactive Mode**: Support for both background and interactive agent execution

## Prerequisites

- **Docker Desktop** (Windows/macOS) or **Docker Engine** (Linux)
- **Docker Compose** (included with Docker Desktop, or install separately)
- **Cursor API Key** (for authentication)

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/stancsz/cursor-sandbox.git
cd cursor-sandbox
```

### 2. Configure Environment

Create a `.env` file from the example:

```bash
cp .env.example .env
```

Edit `.env` and add your Cursor API key:

```bash
CURSOR_API_KEY=your_cursor_api_key_here
```

### 3. Build and Start

**Windows (PowerShell):**
```powershell
.\scripts\run-docker.ps1
```

**macOS/Linux:**
```bash
chmod +x scripts/run-docker.sh
./scripts/run-docker.sh
```

**Or manually:**
```bash
docker compose up --build -d
```

### 4. Verify Installation

Check that the container is running:

```bash
docker ps
```

View agent logs:

```bash
docker exec cursor-agent tail -n 20 /workspace/cursor-agent.log
```

## Usage

### Entering the Container

```bash
docker exec -it cursor-agent bash
```

### Running the Agent Interactively

**Using helper script:**
```bash
# macOS/Linux
./scripts/run-agent-interactive.sh

# Windows PowerShell
.\scripts\run-agent-interactive.ps1
```

**Manual method:**
```bash
docker exec -it cursor-agent cursor-agent
```

### Using the `cursor-win` Command (Quick Access - Windows)

For convenience, you can add the `cursor-win` command to your PATH to run the agent from anywhere on Windows.

**Windows Setup:**
```powershell
# Run the setup script (adds scripts directory to PATH)
.\scripts\setup-cursor-command.ps1
```

After setup, you can use `cursor-win` from any directory:
```powershell
# Run in current directory
cursor-win

# Or explicitly
cursor-win .

# Run in a specific directory
cursor-win C:\path\to\your\project
```

**How it works on Windows:**
- `cursor-win.cmd` → calls `cursor-win.ps1` → calls `run-agent-interactive.ps1` (Windows PowerShell version)
- Uses Docker to run the cursor-agent in a container
- All Windows-compatible, no `.sh` scripts involved

**Linux/macOS Setup:**
```bash
# Make scripts executable
chmod +x scripts/cursor.sh scripts/run-agent-interactive.sh

# Add to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$PATH:/path/to/cursor-sandbox/scripts"

# Or create a symlink
ln -s /path/to/cursor-sandbox/scripts/cursor.sh /usr/local/bin/cursor
```

**Manual PATH Setup (Windows):**
1. Add the `scripts/` directory to your system PATH
2. Restart your terminal
3. Use `cursor-win` command from anywhere

The `cursor-win` command (Windows) and `cursor.sh` (Linux/macOS) are wrappers that call the appropriate `run-agent-interactive` script (`.ps1` on Windows, `.sh` on Linux/macOS) with the specified workspace path.

### Managing the Sandbox Directory

The `sandbox/` directory is shared between your host machine and the container. Use it to share files with the Cursor agent.

**Clear sandbox (preserves README.md and .gitkeep):**

```bash
# macOS/Linux
./scripts/clear-sandbox.sh

# Windows PowerShell
.\scripts\clear-sandbox.ps1
```

## Project Structure

```
.
├── docker/
│   ├── Dockerfile                      # Container image definition
│   ├── docker-entrypoint.sh           # Main entrypoint script
│   └── docker-entrypoint-interactive.sh # Interactive mode entrypoint
├── docker-compose.yml                  # Docker Compose configuration
├── scripts/
│   ├── run-docker.sh                   # Build & start script (macOS/Linux)
│   ├── run-docker.ps1                  # Build & start script (Windows)
│   ├── run-agent-interactive.sh        # Interactive agent script (macOS/Linux)
│   ├── run-agent-interactive.ps1       # Interactive agent script (Windows)
│   ├── clear-sandbox.sh                # Clear sandbox script (macOS/Linux)
│   ├── clear-sandbox.ps1               # Clear sandbox script (Windows)
│   ├── cursor.sh                       # Cursor command wrapper (Linux/macOS)
│   ├── cursor-win.ps1                  # Cursor command wrapper (PowerShell, Windows)
│   ├── cursor-win.cmd                   # Cursor command wrapper (CMD, calls cursor-win.ps1)
│   └── setup-cursor-command.ps1        # Setup script to add cursor-win to PATH (Windows)
├── docs/
│   ├── INTERACTIVE.md                  # Interactive mode documentation
│   └── TESTING.md                      # Testing guide
├── sandbox/                            # Shared workspace directory
│   └── .gitkeep                        # Git placeholder
├── .env.example                        # Environment variables template
└── README.md                           # This file
```

## Configuration

### Environment Variables

The `.env` file supports the following variables:

```bash
# Required: Your Cursor API key for authentication
CURSOR_API_KEY=your_cursor_api_key_here

# Add any other environment variables your setup needs below
```

### Docker Compose Options

Key configuration options in `docker-compose.yml`:

- **INSTALL_CURSOR**: Set to `"false"` to skip CLI installation during build
- **Volumes**:
  - `./sandbox:/workspace:rw` - Mounts only the `sandbox/` directory to `/workspace`

## Common Commands

### Container Management

```bash
# Start container
docker compose up -d

# Stop container
docker compose down

# Rebuild container
docker compose up --build -d

# View logs
docker compose logs -f cursor-agent

# Check container status
docker ps
```

### Agent Operations

```bash
# View agent logs
docker exec cursor-agent tail -n 50 /workspace/cursor-agent.log

# Follow logs in real-time
docker exec cursor-agent tail -f /workspace/cursor-agent.log

# Stop background agent
docker exec cursor-agent pkill cursor-agent

# Check if agent is running
docker exec cursor-agent pgrep cursor-agent
```

### File Operations

```bash
# List files in workspace
docker exec cursor-agent ls -la /workspace

# List files in sandbox
docker exec cursor-agent ls -la /workspace/sandbox

# Copy file to container
docker cp local-file.txt cursor-agent:/workspace/sandbox/

# Copy file from container
docker cp cursor-agent:/workspace/sandbox/file.txt ./
```

## Troubleshooting

### Docker Not Found

**Windows:**
- Install Docker Desktop from [docker.com](https://docs.docker.com/desktop/install/windows/)
- Ensure Docker Desktop is running before executing commands

**macOS:**
- Install Docker Desktop from [docker.com](https://docs.docker.com/desktop/install/mac-install/)
- Start Docker Desktop from Applications

**Linux:**
- Install Docker Engine: `sudo apt-get install docker.io docker-compose`
- Ensure Docker daemon is running: `sudo systemctl start docker`

### Cursor CLI Installation Failed

If the CLI installation fails during build, install manually:

```bash
docker exec -it cursor-agent bash
curl https://cursor.com/install -fsS | bash
export PATH="/root/.local/bin:$PATH"
```

### Authentication Issues

1. Verify your API key is set:
   ```bash
   docker exec cursor-agent env | grep CURSOR
   ```

2. Check `.env` file exists and contains `CURSOR_API_KEY`

3. Restart container after changing `.env`:
   ```bash
   docker compose down
   docker compose up -d
   ```

### Container Won't Start

1. Check Docker logs:
   ```bash
   docker compose logs cursor-agent
   ```

2. Verify Docker resources (CPU/Memory) in Docker Desktop settings

3. Try rebuilding:
   ```bash
   docker compose down
   docker compose up --build -d
   ```

### Files Not Visible in Container

1. Verify volume mounts:
   ```bash
   docker exec cursor-agent ls -la /workspace
   ```

2. Check `docker-compose.yml` volumes section

3. Restart container:
   ```bash
   docker compose restart
   ```

## Background vs Interactive Mode

### Background Mode (Default)

- Agent runs automatically on container startup
- Logs written to `/workspace/cursor-agent.log`
- Container stays alive for exec access
- Best for: Production use, long-running sessions

### Interactive Mode

- Agent runs in foreground
- Output shown directly in terminal
- Easier to debug and see real-time output
- Best for: Development, testing, debugging

See [docs/INTERACTIVE.md](docs/INTERACTIVE.md) for detailed interactive mode documentation.

## Development

### Building the Image

```bash
docker compose build
```

### Skipping Cursor Installation

To skip Cursor CLI installation during build (install manually later):

1. Edit `docker-compose.yml`
2. Set `INSTALL_CURSOR: "false"`
3. Rebuild: `docker compose up --build -d`

### Custom Entrypoint

The entrypoint script (`docker/docker-entrypoint.sh`) handles:
- Loading `.env` file
- Configuring Cursor CLI with API key
- Starting cursor-agent in background (if available)

## Documentation

- [Interactive Mode Guide](docs/INTERACTIVE.md) - Detailed guide for running the agent interactively
- [Testing Guide](docs/TESTING.md) - Testing and verification procedures

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

[Add your license here]

## Support

For issues and questions:
- Check the [Troubleshooting](#troubleshooting) section
- Review the documentation in `docs/`
- Open an issue on GitHub

## Notes

- The container runs `cursor-agent` automatically in the background on startup if the CLI is installed
- Logs are written to `/workspace/cursor-agent.log` inside the container
- The container stays alive with `tail -f /dev/null` so you can exec into it
- Set `INSTALL_CURSOR=false` in docker-compose.yml to skip CLI installation during build
- Use interactive mode for debugging or when you need to see real-time output
