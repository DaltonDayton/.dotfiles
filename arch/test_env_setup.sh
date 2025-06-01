#!/usr/bin/bash

# Test script for the new .env setup functionality
# This script tests the environment detection and setup without running the full install

set -e

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"

# Source common functions
source "$MODULES_DIR/common.sh"

echo "🧪 Testing environment detection and .env setup..."
echo "=================================================="
echo

# Test environment detection
echo "1. Testing environment detection:"
detected_env=$(detect_environment)
echo "   Detected environment: $detected_env"
echo

# Test with existing .env file
if [ -f "$SCRIPT_DIR/.env" ]; then
    echo "2. Testing with existing .env file:"
    echo "   Found existing .env file - would load it normally"
    echo "   Contents:"
    cat "$SCRIPT_DIR/.env" | sed 's/^/   /'
    echo
else
    echo "2. No existing .env file found"
    echo "   This would trigger the interactive setup wizard"
    echo
fi

# Test git config detection
echo "3. Testing git configuration detection:"
if command -v git &>/dev/null; then
    current_git_name=$(git config --global user.name 2>/dev/null || echo "")
    current_git_email=$(git config --global user.email 2>/dev/null || echo "")
    
    if [ -n "$current_git_name" ]; then
        echo "   Found git name: $current_git_name"
    else
        echo "   No git name configured"
    fi
    
    if [ -n "$current_git_email" ]; then
        echo "   Found git email: $current_git_email"
    else
        echo "   No git email configured"
    fi
else
    echo "   Git not available"
fi
echo

echo "✅ Environment setup test completed!"
echo
echo "To test the full interactive setup:"
echo "1. Backup your current .env: mv .env .env.backup"
echo "2. Run: ./install.sh"
echo "3. Follow the prompts"
echo "4. Restore if needed: mv .env.backup .env"
