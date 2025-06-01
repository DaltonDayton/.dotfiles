#!/usr/bin/bash

# Test script for the dependency resolution system
# This script validates dependency declarations and resolution without installing

set -e

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"

# Source common functions and dependencies
source "$MODULES_DIR/common.sh"
source "$MODULES_DIR/dependencies.sh"

echo "🧪 Testing module dependency resolution..."
echo "=========================================="
echo

# Test 1: Display all declared dependencies
echo "1. Declared module dependencies:"
for module in "${!MODULE_DEPENDENCIES[@]}"; do
    deps="${MODULE_DEPENDENCIES[$module]}"
    echo "   $module → $deps"
done
echo

# Test 2: Test dependency resolution with a sample set
echo "2. Testing dependency resolution:"
test_modules=("neovim" "tmux" "shell")
echo "   Input modules: ${test_modules[*]}"

resolved=($(resolve_dependencies "${test_modules[@]}"))
echo "   Resolved order: ${resolved[*]}"
echo

# Test 3: Test with all available modules
echo "3. Testing with all available modules:"
all_modules=()
for module_dir in "$MODULES_DIR"/*/; do
    module_name=$(basename "$module_dir")
    # Skip special directories
    if [[ "$module_name" != "_example_module" && "$module_name" != "common.sh" && "$module_name" != "dependencies.sh" ]]; then
        if [[ -f "$module_dir/$module_name.sh" ]]; then
            all_modules+=("$module_name")
        fi
    fi
done

echo "   Available modules: ${all_modules[*]}"

if [[ ${#all_modules[@]} -gt 0 ]]; then
    all_resolved=($(resolve_dependencies "${all_modules[@]}"))
    echo "   Full resolution order: ${all_resolved[*]}"
else
    echo "   No modules found to test"
fi
echo

# Test 4: Validate that all dependencies exist
echo "4. Validating dependency references:"
missing_deps=()
for module in "${!MODULE_DEPENDENCIES[@]}"; do
    deps="${MODULE_DEPENDENCIES[$module]}"
    for dep in $deps; do
        if [[ ! -f "$MODULES_DIR/$dep/$dep.sh" ]]; then
            missing_deps+=("$module → $dep")
        fi
    done
done

if [[ ${#missing_deps[@]} -eq 0 ]]; then
    echo "   ✅ All dependency references are valid"
else
    echo "   ⚠️  Found missing dependency references:"
    for missing in "${missing_deps[@]}"; do
        echo "      $missing"
    done
fi
echo

echo "✅ Dependency resolution test completed!"
echo
echo "To test with actual modules enabled:"
echo "1. Edit install.sh and uncomment some modules in the MODULES array"
echo "2. Run: ./install.sh"
echo "3. Observe the dependency resolution and installation order"
