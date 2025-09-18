#!/bin/bash

# Start all MCP servers in the background
echo "Starting MCP servers..."

# Start Playwright MCP server
cd /home/azureuser/mcp-servers/mcp-playwright
npx playwright-mcp-server &
PLAYWRIGHT_PID=$!

# Start Filesystem MCP server
cd /home/azureuser/mcp-servers/mcp-servers-official/src/filesystem
npx mcp-server-filesystem /home/azureuser &
FILESYSTEM_PID=$!

# Start Git MCP server
cd /home/azureuser/mcp-servers/git-mcp-server
source venv/bin/activate
python -m mcp_server_git &
GIT_PID=$!

echo "MCP servers started with PIDs:"
echo "Playwright: $PLAYWRIGHT_PID"
echo "Filesystem: $FILESYSTEM_PID"
echo "Git: $GIT_PID"

# Function to stop all servers
cleanup() {
    echo "Stopping MCP servers..."
    kill $PLAYWRIGHT_PID $FILESYSTEM_PID $GIT_PID 2>/dev/null
    echo "MCP servers stopped."
    exit 0
}

# Trap SIGINT and SIGTERM to stop servers gracefully
trap cleanup SIGINT SIGTERM

# Wait for all background processes
wait $PLAYWRIGHT_PID $FILESYSTEM_PID $GIT_PID