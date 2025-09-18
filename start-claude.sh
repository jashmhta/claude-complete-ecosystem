#!/bin/bash
echo "🚀 Starting Claude Code Ecosystem..."
echo "Starting MCP servers..."
claude mcp start claude-flow &
claude mcp start ruv-swarm &
claude mcp start flow-nexus &
sleep 3
echo "Starting Claude Code..."
claude
