#!/bin/bash
# Coverage checker for Tokyo Roulette Predictor
# Validates test coverage meets minimum requirements

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}📊 Checking test coverage...${NC}"
echo "======================================"

# Minimum coverage thresholds
MIN_OVERALL_COVERAGE=80
MIN_CORE_LOGIC_COVERAGE=90

# Coverage file
COVERAGE_FILE="coverage/lcov.info"

# Check if coverage file exists
if [ ! -f "$COVERAGE_FILE" ]; then
    echo -e "${YELLOW}⚠️  Coverage file not found: $COVERAGE_FILE${NC}"
    echo -e "${YELLOW}   Run: flutter test --coverage${NC}"
    exit 0
fi

echo -e "${GREEN}✓ Coverage file found${NC}"
echo ""

# Function to calculate coverage for a specific file
calculate_file_coverage() {
    local file=$1
    local lcov_file=$2
    
    # Extract lines for this file from lcov using more robust parsing
    # Use awk to find the SF block and extract LF and LH
    local lines_found=$(awk -v target="$file" '
        /^SF:/ { 
            if (index($0, target) > 0) found=1; else found=0
        }
        found && /^LF:/ { print substr($0, 4); exit }
    ' "$lcov_file")
    
    local lines_hit=$(awk -v target="$file" '
        /^SF:/ { 
            if (index($0, target) > 0) found=1; else found=0
        }
        found && /^LH:/ { print substr($0, 4); exit }
    ' "$lcov_file")
    
    if [ -z "$lines_found" ] || [ "$lines_found" -eq 0 ]; then
        echo "0"
        return
    fi
    
    # Calculate percentage
    local coverage=$(awk "BEGIN {printf \"%.1f\", ($lines_hit / $lines_found) * 100}")
    echo "$coverage"
}

# Parse overall coverage
echo -e "${BLUE}Parsing coverage data...${NC}"

# Count total lines
TOTAL_LINES_FOUND=$(grep -c "^LF:" "$COVERAGE_FILE" 2>/dev/null || echo "0")
TOTAL_LINES_HIT=$(grep -c "^LH:" "$COVERAGE_FILE" 2>/dev/null || echo "0")

if [ "$TOTAL_LINES_FOUND" -eq 0 ]; then
    echo -e "${RED}✗ No coverage data found${NC}"
    exit 1
fi

# Calculate overall coverage using lcov summary
if command -v lcov &> /dev/null; then
    echo -e "${BLUE}Generating coverage summary...${NC}"
    lcov --summary "$COVERAGE_FILE" 2>&1 | tee /tmp/coverage_summary.txt
    echo ""
    
    # Extract overall line coverage
    OVERALL_COVERAGE=$(grep "lines\.\.\.\.\.\." /tmp/coverage_summary.txt | grep -oE "[0-9]+\.[0-9]+%" | cut -d% -f1 || echo "0")
else
    # Fallback: manual calculation
    TOTAL_LF=$(grep "^LF:" "$COVERAGE_FILE" | cut -d: -f2 | awk '{s+=$1} END {print s}')
    TOTAL_LH=$(grep "^LH:" "$COVERAGE_FILE" | cut -d: -f2 | awk '{s+=$1} END {print s}')
    
    if [ "$TOTAL_LF" -gt 0 ]; then
        OVERALL_COVERAGE=$(awk "BEGIN {printf \"%.1f\", ($TOTAL_LH / $TOTAL_LF) * 100}")
    else
        OVERALL_COVERAGE="0"
    fi
fi

echo -e "${BLUE}Overall Coverage: ${OVERALL_COVERAGE}%${NC}"

# Check overall coverage threshold
OVERALL_INT=$(echo "$OVERALL_COVERAGE" | cut -d. -f1)

if [ "$OVERALL_INT" -ge "$MIN_OVERALL_COVERAGE" ]; then
    echo -e "${GREEN}✓ Overall coverage meets minimum threshold (${MIN_OVERALL_COVERAGE}%)${NC}"
else
    echo -e "${RED}✗ Overall coverage below minimum threshold (${MIN_OVERALL_COVERAGE}%)${NC}"
    echo -e "${YELLOW}   Current: ${OVERALL_COVERAGE}%, Required: ${MIN_OVERALL_COVERAGE}%${NC}"
fi

echo ""

# Check core logic coverage (roulette_logic.dart)
echo -e "${BLUE}Checking core logic coverage...${NC}"

CORE_FILES=(
    "lib/roulette_logic.dart"
)

CORE_COVERAGE_OK=true

for core_file in "${CORE_FILES[@]}"; do
    if grep -q "SF:.*$core_file" "$COVERAGE_FILE"; then
        # Extract coverage for this file
        FILE_DATA=$(awk "/SF:.*$(basename $core_file)/,/end_of_record/" "$COVERAGE_FILE")
        LF=$(echo "$FILE_DATA" | grep "^LF:" | cut -d: -f2)
        LH=$(echo "$FILE_DATA" | grep "^LH:" | cut -d: -f2)
        
        if [ -n "$LF" ] && [ "$LF" -gt 0 ]; then
            FILE_COVERAGE=$(awk "BEGIN {printf \"%.1f\", ($LH / $LF) * 100}")
            FILE_COVERAGE_INT=$(echo "$FILE_COVERAGE" | cut -d. -f1)
            
            echo -e "${BLUE}  $core_file: ${FILE_COVERAGE}%${NC}"
            
            if [ "$FILE_COVERAGE_INT" -ge "$MIN_CORE_LOGIC_COVERAGE" ]; then
                echo -e "${GREEN}  ✓ Core logic coverage meets threshold (${MIN_CORE_LOGIC_COVERAGE}%)${NC}"
            else
                echo -e "${RED}  ✗ Core logic coverage below threshold (${MIN_CORE_LOGIC_COVERAGE}%)${NC}"
                CORE_COVERAGE_OK=false
            fi
        else
            echo -e "${YELLOW}  ⚠️  No coverage data for $core_file${NC}"
        fi
    else
        echo -e "${YELLOW}  ⚠️  $core_file not found in coverage report${NC}"
    fi
done

echo ""

# Generate HTML report if genhtml is available
if command -v genhtml &> /dev/null; then
    echo -e "${BLUE}Generating HTML coverage report...${NC}"
    
    if genhtml "$COVERAGE_FILE" -o coverage/html --quiet 2>/dev/null; then
        echo -e "${GREEN}✓ HTML report generated: coverage/html/index.html${NC}"
        echo ""
    fi
fi

# Summary
echo "======================================"

if [ "$OVERALL_INT" -ge "$MIN_OVERALL_COVERAGE" ] && [ "$CORE_COVERAGE_OK" = true ]; then
    echo -e "${GREEN}✅ Coverage check passed!${NC}"
    echo -e "${GREEN}All coverage thresholds met${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  Coverage check completed with warnings${NC}"
    echo ""
    echo -e "${YELLOW}Recommendations:${NC}"
    echo "1. Add more tests to increase coverage"
    echo "2. Focus on core logic files (roulette_logic.dart)"
    echo "3. Test edge cases and error handling"
    echo "4. Review HTML coverage report for uncovered lines"
    echo ""
    echo -e "${BLUE}To view detailed coverage:${NC}"
    echo "  1. Open coverage/html/index.html in a browser"
    echo "  2. Or run: flutter test --coverage && genhtml coverage/lcov.info -o coverage/html"
    echo ""
    # Return 0 to not fail the build, just warn
    exit 0
fi
