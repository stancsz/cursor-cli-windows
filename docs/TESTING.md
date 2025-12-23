# Testing the Docker Setup

## Prerequisites

1. **Start Docker Desktop** - Make sure Docker Desktop is running on your Windows machine
2. Wait until Docker Desktop shows "Docker is running"

## Step 1: Build and Start the Container

Run the helper script:
```powershell
.\scripts\run-docker.ps1
```

Or manually:
```powershell
docker compose up --build -d
```

## Step 2: Verify Hello World Files

I've created several hello world files in the `sandbox/` directory:

- `hello-world.txt` - Simple text file
- `hello.py` - Python hello world script
- `hello.js` - JavaScript hello world script
- `README.md` - Documentation for the sandbox

### Test the files are accessible in the container:

**Option 1: Use the test script**
```powershell
.\scripts\test-hello-world.ps1
```

**Option 2: Manual testing**
```powershell
# Enter the container
docker exec -it cursor-agent bash

# List files in sandbox
ls -la /workspace/sandbox

# View hello world text
cat /workspace/sandbox/hello-world.txt

# Run Python script
python3 /workspace/sandbox/hello.py

# Run JavaScript (if node is installed)
node /workspace/sandbox/hello.js

# Exit container
exit
```

## Step 3: Verify Container is Running

```powershell
docker ps
```

You should see the `cursor-agent` container running.

## Step 4: Check Cursor Agent Logs

```powershell
docker exec cursor-agent tail -n 20 /workspace/cursor-agent.log
```

## Troubleshooting

### Docker daemon not running
- Start Docker Desktop
- Wait for it to fully start (check system tray icon)
- Verify with: `docker info`

### Container fails to start
- Check logs: `docker compose logs cursor-agent`
- Rebuild: `docker compose up --build -d`
- Check Docker Desktop resources (CPU/Memory)

### Files not visible in container
- Verify volume mount: `docker exec cursor-agent ls -la /workspace`
- Check docker-compose.yml volumes section
- Restart container: `docker compose restart`

