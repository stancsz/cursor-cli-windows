# Cursor CLI Docker Setup for Windows

A containerized development environment for running the Cursor CLI agent on **Windows** using Docker. This project provides a complete setup for running Cursor's AI-powered coding assistant in an isolated, reproducible container environment, specifically designed for Windows users.

> ## Quick Setup AI Prompt
> To install `cursor-win` on your Windows computer, copy this prompt for your AI agent:
> ```
> Install cursor-win on my Windows computer by:
> 1. Cloning the repository from https://github.com/stancsz/cursor-cli-windows.git
> 2. Getting my CURSOR_API_KEY from https://cursor.com/dashboard?tab=cloud-agents
> 3. Creating a .env file from .env.example and adding my CURSOR_API_KEY
> 4. Running the setup script (.\scripts\setup-cursor-command.ps1) to add cursor-win to PATH
> 5. Building and starting the Docker container using .\scripts\run-docker.ps1
> 6. Verifying the installation works by running cursor-win from any directory
> ```


## Why This Project?

Running the Cursor CLI on Windows can be challenging due to several factors:

- **Installation Complexity**: The Cursor CLI installer is primarily designed for Unix-like systems (Linux/macOS), making native Windows installation difficult or unreliable
- **Dependency Issues**: Windows lacks many of the native dependencies that Cursor CLI expects, requiring complex workarounds or WSL (Windows Subsystem for Linux)
- **Path and Environment Problems**: Windows path handling, line endings (CRLF vs LF), and environment variable management differ significantly from Unix systems, causing configuration headaches
- **WSL Overhead**: While WSL can work, it adds complexity, requires additional setup, and may have performance overhead or compatibility issues
- **No Native Windows Support**: Cursor CLI doesn't have official Windows binaries, forcing users to rely on workarounds

**This project solves these problems** by:
- ✅ Running Cursor CLI in a Docker container (Linux environment) on Windows
- ✅ Providing simple PowerShell scripts that handle all the complexity
- ✅ Automatically managing Docker, environment variables, and configuration
- ✅ Offering a single `cursor-win` command that works from anywhere
- ✅ Eliminating the need for WSL or manual Linux-like environment setup
- ✅ Handling Windows-specific issues (path conversion, line endings, etc.) automatically

## Overview

This repository provides a Docker-based solution for running the Cursor CLI agent on Windows, making it easy to:
- Run Cursor agent in a consistent, isolated environment on Windows
- Share workspace files between Windows host and container
- Manage agent configuration and authentication
- Run the agent in background or interactive modes
- Use a simple `cursor-win` command from anywhere on your system

## Features

- 🪟 **Windows-First**: Designed specifically for Windows with PowerShell scripts and native Windows support
- 🐳 **Docker-based**: Fully containerized setup using Docker Compose
- 🔐 **Secure Configuration**: Environment-based API key management
- 📁 **Volume Mounting**: Full workspace access with shared sandbox directory
- 🚀 **Quick Start**: Simple PowerShell scripts for easy setup and usage
- 📊 **Logging**: Automatic log file generation for background operations
- 🔄 **Interactive Mode**: Support for both background and interactive agent execution
- ⌨️ **Command Line Tool**: `cursor-win` command available system-wide after setup

## Prerequisites

- **Windows 10/11** (this project is designed for Windows)
- **Docker Desktop for Windows** - Install from [docker.com](https://docs.docker.com/desktop/install/windows/)
- **PowerShell** (included with Windows)
- **Cursor API Key** (for authentication) - Get yours from [cursor.com/dashboard?tab=cloud-agents](https://cursor.com/dashboard?tab=cloud-agents)

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/stancsz/cursor-cli-windows.git
cd cursor-cli-windows
```

### 2. Configure Environment

Create a `.env` file from the example:

```powershell
Copy-Item .env.example .env
```

Or manually create `.env` and add your Cursor API key (get it from [cursor.com/dashboard?tab=cloud-agents](https://cursor.com/dashboard?tab=cloud-agents)):

```powershell
CURSOR_API_KEY=your_cursor_api_key_here
```

### 3. Build and Start

**Using the helper script (recommended):**
```powershell
.\scripts\run-docker.ps1
```

**Or manually:**
```powershell
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

**Using the helper script (recommended):**
```powershell
.\scripts\run-agent-interactive.ps1
```

**Or with a custom workspace path:**
```powershell
.\scripts\run-agent-interactive.ps1 C:\path\to\your\project
```

**Manual method:**
```powershell
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

**How it works:**
- `cursor-win.cmd` → calls `cursor-win.ps1` → calls `run-agent-interactive.ps1` (Windows PowerShell)
- Uses Docker to run the cursor-agent in a container
- All Windows-compatible PowerShell scripts
- Automatically checks if Docker is running before proceeding

**Manual PATH Setup:**
1. Add the `scripts/` directory to your system PATH
2. Restart your terminal
3. Use `cursor-win` command from anywhere

**Note:** Bash scripts (`.sh`) are included for reference but this project is optimized for Windows. The primary workflow uses PowerShell scripts.

### Managing the Sandbox Directory

The `sandbox/` directory is shared between your host machine and the container. Use it to share files with the Cursor agent.

**Clear sandbox (preserves README.md and .gitkeep):**

```powershell
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
│   ├── run-docker.ps1                  # Build & start script (Windows - primary)
│   ├── run-agent-interactive.ps1       # Interactive agent script (Windows - primary)
│   ├── clear-sandbox.ps1               # Clear sandbox script (Windows - primary)
│   ├── cursor-win.ps1                  # Cursor command wrapper (PowerShell)
│   ├── cursor-win.cmd                   # Cursor command wrapper (CMD, calls cursor-win.ps1)
│   ├── setup-cursor-command.ps1        # Setup script to add cursor-win to PATH
│   ├── run-docker.sh                   # Build & start script (bash - reference)
│   ├── run-agent-interactive.sh        # Interactive agent script (bash - reference)
│   ├── clear-sandbox.sh                # Clear sandbox script (bash - reference)
│   └── cursor.sh                       # Cursor command wrapper (bash - reference)
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
- The scripts will automatically check if Docker is running and prompt you to start it if needed

### Cursor CLI Installation Failed

If the CLI installation fails during build, install manually:

```powershell
docker exec -it cursor-agent bash
curl https://cursor.com/install -fsS | bash
export PATH="/root/.local/bin:$PATH"
```

### Authentication Issues

1. Verify your API key is set:
   ```powershell
   docker exec cursor-agent env | grep CURSOR
   ```

2. Check `.env` file exists and contains `CURSOR_API_KEY`

3. Restart container after changing `.env`:
   ```powershell
   docker compose down
   docker compose up -d
   ```

### Container Won't Start

1. Check Docker logs:
   ```powershell
   docker compose logs cursor-agent
   ```

2. Verify Docker resources (CPU/Memory) in Docker Desktop settings

3. Ensure Docker Desktop is running (scripts will check this automatically)

4. Try rebuilding:
   ```powershell
   docker compose down
   docker compose up --build -d
   ```

### Files Not Visible in Container

1. Verify volume mounts:
   ```powershell
   docker exec cursor-agent ls -la /workspace
   ```

2. Check `docker-compose.yml` volumes section

3. Restart container:
   ```powershell
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

```powershell
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

- **Windows-focused**: This project is designed and optimized for Windows users
- The container runs `cursor-agent` automatically in the background on startup if the CLI is installed
- Logs are written to `/workspace/cursor-agent.log` inside the container
- The container stays alive with `tail -f /dev/null` so you can exec into it
- Set `INSTALL_CURSOR=false` in docker-compose.yml to skip CLI installation during build
- Use interactive mode for debugging or when you need to see real-time output
- All scripts automatically check if Docker is running before proceeding
- Bash scripts (`.sh`) are included for reference but PowerShell scripts (`.ps1`) are the primary interface
