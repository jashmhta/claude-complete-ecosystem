#!/bin/bash

echo "🚀 Starting MCP Services..."

# Start Byterover MCP Server
echo "Starting Byterover MCP Server..."
cd /home/azureuser/mcp-analysis/byterover-mcp
nohup ./venv/bin/python mcp_server.py > /tmp/mcp-byterover.log 2>&1 &
echo "Byterover started (PID: $!)"

# Start Git MCP Server
echo "Starting Git MCP Server..."
cd /home/azureuser/mcp-servers/git-mcp-server
nohup ./venv/bin/python -m mcp_server_git > /tmp/mcp-git.log 2>&1 &
echo "Git MCP started (PID: $!)"

# Start Filesystem MCP Server
echo "Starting Filesystem MCP Server..."
cd /home/azureuser/mcp-servers/mcp-servers-official/src/filesystem
nohup npx mcp-server-filesystem /home/azureuser > /tmp/mcp-filesystem.log 2>&1 &
echo "Filesystem MCP started (PID: $!)"

echo "✅ MCP Services Started!"