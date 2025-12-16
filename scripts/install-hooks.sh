#!/bin/bash
# Install Git hooks for Tokyo Roulette Predictor
# This script installs hooks from .githooks/ to .git/hooks/

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Installing Git hooks...${NC}"
echo "======================================"

# Check if .git directory exists
if [ ! -d ".git" ]; then
    echo -e "${RED}Error: .git directory not found${NC}"
    echo "This script must be run from the repository root"
    exit 1
fi

# Check if .githooks directory exists
if [ ! -d ".githooks" ]; then
    echo -e "${RED}Error: .githooks directory not found${NC}"
    exit 1
fi

# Install hooks
HOOKS_INSTALLED=0
HOOKS_FAILED=0

for hook in .githooks/*; do
    if [ -f "$hook" ]; then
        hook_name=$(basename "$hook")
        target=".git/hooks/$hook_name"
        
        echo -e "${BLUE}Installing $hook_name...${NC}"
        
        # Copy hook to .git/hooks/
        if cp "$hook" "$target"; then
            # Make it executable
            chmod +x "$target"
            echo -e "${GREEN}✓ Installed $hook_name${NC}"
            HOOKS_INSTALLED=$((HOOKS_INSTALLED + 1))
        else
            echo -e "${RED}✗ Failed to install $hook_name${NC}"
            HOOKS_FAILED=$((HOOKS_FAILED + 1))
        fi
    fi
done

echo "======================================"

if [ $HOOKS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ Successfully installed $HOOKS_INSTALLED hook(s)${NC}"
    echo ""
    echo -e "${BLUE}Installed hooks:${NC}"
    ls -1 .git/hooks/ | grep -v ".sample" || echo "None"
    echo ""
    echo -e "${YELLOW}Note: Hooks will run automatically on git commands${NC}"
    echo -e "${YELLOW}You can bypass hooks with: git commit --no-verify${NC}"
else
    echo -e "${RED}❌ Failed to install $HOOKS_FAILED hook(s)${NC}"
    exit 1
fi

exit 0
