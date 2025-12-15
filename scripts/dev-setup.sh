#!/bin/bash
# Development setup script for Tokyo Roulette Predictor
# Sets up the complete development environment

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "=========================================="
echo "  Tokyo Roulette Predictor"
echo "  Development Environment Setup"
echo "=========================================="
echo -e "${NC}"

EXIT_CODE=0

# 1. Check Flutter installation
echo -e "${BLUE}Step 1: Checking Flutter installation...${NC}"
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    echo -e "${GREEN}✓ Flutter is installed${NC}"
    echo -e "  Version: $FLUTTER_VERSION"
    
    # Verify Flutter version
    echo -e "${BLUE}Verifying Flutter version compatibility...${NC}"
    FLUTTER_VERSION_NUM=$(flutter --version | grep -oP 'Flutter \K[0-9]+\.[0-9]+' || echo "0.0")
    MAJOR=$(echo $FLUTTER_VERSION_NUM | cut -d. -f1)
    MINOR=$(echo $FLUTTER_VERSION_NUM | cut -d. -f2)
    
    if [ "$MAJOR" -ge 3 ]; then
        echo -e "${GREEN}✓ Flutter version is compatible (>= 3.0.0)${NC}"
    else
        echo -e "${YELLOW}⚠️  Flutter version may be outdated (requires >= 3.0.0)${NC}"
        echo -e "${YELLOW}   Consider upgrading: flutter upgrade${NC}"
        EXIT_CODE=1
    fi
else
    echo -e "${RED}✗ Flutter is not installed${NC}"
    echo -e "${YELLOW}Please install Flutter from:${NC}"
    echo -e "  https://docs.flutter.dev/get-started/install"
    EXIT_CODE=1
fi
echo ""

# 2. Check Dart installation
echo -e "${BLUE}Step 2: Checking Dart installation...${NC}"
if command -v dart &> /dev/null; then
    DART_VERSION=$(dart --version 2>&1 | head -n 1)
    echo -e "${GREEN}✓ Dart is installed${NC}"
    echo -e "  Version: $DART_VERSION"
else
    echo -e "${YELLOW}⚠️  Dart command not found (usually comes with Flutter)${NC}"
fi
echo ""

# 3. Check Git installation
echo -e "${BLUE}Step 3: Checking Git installation...${NC}"
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    echo -e "${GREEN}✓ Git is installed${NC}"
    echo -e "  Version: $GIT_VERSION"
else
    echo -e "${RED}✗ Git is not installed${NC}"
    EXIT_CODE=1
fi
echo ""

# If Flutter is not available, skip remaining steps
if [ $EXIT_CODE -ne 0 ]; then
    echo -e "${RED}=========================================="
    echo -e "Setup cannot continue without Flutter/Git"
    echo -e "${YELLOW}Please install missing tools and run this script again${NC}"
    echo -e "${RED}==========================================${NC}"
    exit 1
fi

# 4. Validate project structure
echo -e "${BLUE}Step 4: Validating project structure...${NC}"
STRUCTURE_VALID=true

required_files=("pubspec.yaml" "lib/main.dart" "lib/roulette_logic.dart" "analysis_options.yaml")
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓ $file${NC}"
    else
        echo -e "${RED}✗ $file missing${NC}"
        STRUCTURE_VALID=false
    fi
done

required_dirs=("lib" "test" "android" "assets")
for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓ $dir/${NC}"
    else
        echo -e "${YELLOW}⚠️  $dir/ missing${NC}"
    fi
done

if [ "$STRUCTURE_VALID" = false ]; then
    echo -e "${RED}✗ Project structure is invalid${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Project structure validated${NC}"
echo ""

# 5. Install dependencies
echo -e "${BLUE}Step 5: Installing Flutter dependencies...${NC}"
if flutter pub get; then
    echo -e "${GREEN}✓ Dependencies installed${NC}"
else
    echo -e "${RED}✗ Failed to install dependencies${NC}"
    exit 1
fi
echo ""

# 6. Install Git hooks
echo -e "${BLUE}Step 6: Installing Git hooks...${NC}"
if [ -f "scripts/install-hooks.sh" ]; then
    if bash scripts/install-hooks.sh; then
        echo -e "${GREEN}✓ Git hooks installed${NC}"
    else
        echo -e "${YELLOW}⚠️  Failed to install Git hooks${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  install-hooks.sh not found, skipping...${NC}"
fi
echo ""

# 7. Run initial build verification
echo -e "${BLUE}Step 7: Verifying build configuration...${NC}"
echo -e "${YELLOW}Running flutter doctor to check setup...${NC}"
flutter doctor
echo ""

# 8. Check for common issues
echo -e "${BLUE}Step 8: Checking for common issues...${NC}"

# Check .gitignore
if grep -q "*.keystore" .gitignore && grep -q "key.properties" .gitignore && grep -q ".env" .gitignore; then
    echo -e "${GREEN}✓ .gitignore includes sensitive files${NC}"
else
    echo -e "${YELLOW}⚠️  .gitignore may be missing some sensitive file patterns${NC}"
fi

# Check for secrets in code (quick check)
if grep -r "sk_live_\|pk_live_\|api_key.*=.*['\"]" lib/ test/ 2>/dev/null | grep -v "example\|TODO\|test"; then
    echo -e "${RED}⚠️  Possible secrets found in code!${NC}"
    echo -e "${YELLOW}   Review and move to environment variables${NC}"
fi

echo ""

# 9. Summary and next steps
echo -e "${CYAN}=========================================="
echo -e "  Setup Complete!"
echo -e "==========================================${NC}"
echo ""
echo -e "${GREEN}✅ Your development environment is ready!${NC}"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo ""
echo -e "  ${GREEN}1.${NC} Run quality checks:"
echo -e "     ${CYAN}make check${NC}"
echo ""
echo -e "  ${GREEN}2.${NC} Format your code:"
echo -e "     ${CYAN}make format${NC}"
echo ""
echo -e "  ${GREEN}3.${NC} Run tests:"
echo -e "     ${CYAN}make test${NC}"
echo ""
echo -e "  ${GREEN}4.${NC} Build the app:"
echo -e "     ${CYAN}flutter run${NC}"
echo -e "     ${CYAN}make build-debug${NC}"
echo ""
echo -e "  ${GREEN}5.${NC} See all available commands:"
echo -e "     ${CYAN}make help${NC}"
echo ""
echo -e "${BLUE}Useful Tips:${NC}"
echo ""
echo -e "  • Pre-commit hooks will run automatically on ${CYAN}git commit${NC}"
echo -e "  • Bypass hooks with: ${CYAN}git commit --no-verify${NC}"
echo -e "  • Run ${CYAN}make check${NC} before pushing to catch issues early"
echo -e "  • Read ${CYAN}CONTRIBUTING.md${NC} for contribution guidelines"
echo ""
echo -e "${YELLOW}Happy coding! 🎰✨${NC}"
echo ""
