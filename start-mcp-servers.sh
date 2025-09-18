#!/bin/bash

# Start all working MCP servers in background
echo "🚀 Starting MCP Servers..."

# Start Byterover MCP Server
echo "Starting Byterover MCP Server..."
cd /home/azureuser/mcp-analysis/byterover-mcp
./venv/bin/python mcp_server.py &
echo "Byterover MCP Server started (PID: $!)"

# Start Git MCP Server
echo "Starting Git MCP Server..."
cd /home/azureuser/mcp-servers/git-mcp-server
./venv/bin/python -m mcp_server_git &
echo "Git MCP Server started (PID: $!)"

# Wait a moment for servers to start
sleep 3

echo "✅ All MCP servers started!"
echo "Check status with: claude mcp list"