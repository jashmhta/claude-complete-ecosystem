#!/bin/bash

# Test script to verify MCP servers work with Claude Code

echo "Testing MCP servers with Claude Code..."

# Test 1: Check if Claude can list the configured MCP servers
echo "Test 1: Listing configured MCP servers"
claude mcp list

# Test 2: Try to use Claude with a simple prompt that would use the filesystem server
echo "Test 2: Testing filesystem access"
echo 'claude "What files are in the /home/azureuser directory?" --print' | bash

# Test 3: Try to use Claude with a prompt that would use the Git server
echo "Test 3: Testing Git repository access"
echo 'claude "What is the status of the git repository in /home/azureuser?" --print' | bash

# Test 4: Try to use Claude with a prompt that would use the Playwright server
echo "Test 4: Testing Playwright capabilities"
echo 'claude "Can you help me automate a browser task using Playwright?" --print' | bash

echo "Tests completed."