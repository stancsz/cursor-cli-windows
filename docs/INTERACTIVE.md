# Running Cursor Agent Interactively

There are several ways to run the cursor agent interactively via Docker and CLI.

## Method 1: Using Helper Scripts (Easiest)

### Windows (PowerShell):
```powershell
.\scripts\run-agent-interactive.ps1
```

### macOS/Linux:
```bash
chmod +x scripts/run-agent-interactive.sh
./scripts/run-agent-interactive.sh
```

## Method 2: Manual Docker Exec

### Step 1: Ensure container is running
```bash
docker compose up -d
```

### Step 2: Run cursor-agent interactively
```bash
docker exec -it cursor-agent cursor-agent
```

This will run the agent in the foreground, showing all output directly in your terminal.

## Method 3: Enter Container and Run Manually

### Step 1: Enter the container
```bash
docker exec -it cursor-agent bash
```

### Step 2: Inside the container, run cursor-agent
```bash
# Make sure you're in the workspace
cd /workspace

# Run cursor-agent interactively
cursor-agent
```

### Step 3: Exit when done
Press `Ctrl+C` to stop the agent, then type `exit` to leave the container.

## Method 4: Override Command for Interactive Mode

You can override the docker-compose command to run cursor-agent directly:

```bash
docker compose run --rm cursor-agent cursor-agent
```

This creates a new container instance, runs cursor-agent, and removes the container when done.

## Method 5: Stop Background Agent and Run Interactively

If the agent is already running in the background (from the entrypoint script):

### Step 1: Stop the background process
```bash
docker exec cursor-agent pkill cursor-agent
```

### Step 2: Run interactively
```bash
docker exec -it cursor-agent cursor-agent
```

## Environment Setup

Before running interactively, ensure your `.env` file is configured:

```bash
CURSOR_API_KEY=your_api_key_here
```

The entrypoint script will automatically configure the CLI when the container starts.

## Viewing Logs

If you want to see what the background agent is doing:

```bash
# View live logs
docker exec cursor-agent tail -f /workspace/cursor-agent.log

# View last 50 lines
docker exec cursor-agent tail -n 50 /workspace/cursor-agent.log
```

## Troubleshooting

### Agent not found
If `cursor-agent` command is not found:
```bash
docker exec -it cursor-agent bash
export PATH="/root/.local/bin:$PATH"
cursor-agent --help
```

### Authentication issues
Check if API key is set:
```bash
docker exec cursor-agent env | grep CURSOR
```

### Container not running
```bash
docker compose up -d
docker ps  # Verify container is running
```

## Differences: Background vs Interactive

- **Background mode** (default): Agent runs in background, logs to file
- **Interactive mode**: Agent runs in foreground, shows output in terminal, easier to debug

Choose interactive mode when:
- Debugging issues
- Want to see real-time output
- Testing configuration changes
- Need to interact with the agent directly

