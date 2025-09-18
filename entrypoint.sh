#!/bin/bash
echo "🚀 Claude Code Complete Ecosystem - Minimal Setup"
echo "📁 Workspace: $(pwd)"
echo "🐍 Python: $(python3 --version)"
echo "📦 Files in workspace:" && ls -la
echo ""
echo "Available setup scripts:"
ls -la *.sh | grep -E "(setup|start|verify)"
echo ""
echo "To run setup: ./claude-complete-setup.sh"
echo "To verify: ./verify-claude-setup.sh"
exec "$@"