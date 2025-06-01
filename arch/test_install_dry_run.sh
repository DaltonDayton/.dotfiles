#!/usr/bin/bash

# Test script to demonstrate dependency resolution without actually installing packages
# This simulates the install process to show how dependencies work

set -e

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"

# Source common functions and dependencies
source "$MODULES_DIR/common.sh"
source "$MODULES_DIR/dependencies.sh"

# Set up mock environment variables for testing
export ENVIRONMENT="arch"
export CONTEXT="personal"
export GIT_NAME="Test User"
export GIT_EMAIL="test@example.com"

# This is a SAFE dry-run script - no actual installation commands are executed
# We only analyze the module scripts to show what WOULD happen

echo "🧪 Dry run test of dependency-aware installation..."
echo "=================================================="
echo

# Test with a realistic set of modules that have dependencies
TEST_MODULES=("neovim" "tmux" "shell" "python")

echo "🎯 Testing with modules: ${TEST_MODULES[*]}"
echo

# Resolve dependencies
echo "🔍 Resolving module dependencies..."
RESOLVED_MODULES=($(resolve_dependencies "${TEST_MODULES[@]}"))

echo "📋 Installation order: ${RESOLVED_MODULES[*]}"
echo

# Simulate installation (SAFE - no actual execution)
for module in "${RESOLVED_MODULES[@]}"; do
  echo "====================="
  echo "Processing $module..."
  echo "====================="

  # Check if module script exists
  MODULE_SCRIPT="$MODULES_DIR/$module/$module.sh"
  if [[ -f "$MODULE_SCRIPT" ]]; then
    echo "   ✅ Module script found: $MODULE_SCRIPT"
    echo "   📋 Dependencies: ${MODULE_DEPENDENCIES[$module]:-none}"

    # Show what packages would be installed (parse from script)
    if grep -q "local packages=(" "$MODULE_SCRIPT"; then
      echo "   � Packages that would be installed:"
      grep -A 10 "local packages=(" "$MODULE_SCRIPT" | grep -E '^\s*"[^"]*"' | sed 's/.*"\([^"]*\)".*/     - \1/'
    fi

    # Show what configs would be symlinked
    if grep -q "symlink_config" "$MODULE_SCRIPT"; then
      echo "   🔗 Configurations that would be symlinked:"
      grep -B 2 -A 2 "symlink_config" "$MODULE_SCRIPT" | grep -E 'CONFIG_(SOURCE|DEST)=' | sed 's/.*="\([^"]*\)".*/     \1/'
    fi

    echo "   ✅ Module '$module' analyzed (NOT EXECUTED)"
  else
    echo "   ❌ Module script not found: $MODULE_SCRIPT"
  fi
  echo
done

echo "🎉 SAFE dry run completed successfully!"
echo
echo "Key observations:"
echo "- Dependencies were resolved automatically"
echo "- Modules were processed in the correct order"
echo "- NO actual installation commands were executed"
echo "- Only analyzed what WOULD happen"
echo
echo "This was a completely safe analysis. To run actual installation:"
echo "1. Update your modules first (they may be out of date)"
echo "2. Edit install.sh and uncomment desired modules"
echo "3. Run: ./install.sh"
