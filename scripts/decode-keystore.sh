#!/bin/bash
#
# decode-keystore.sh
# Decodes a base64-encoded keystore from KEYSTORE_BASE64 environment variable
# and writes it to a secure temporary file.
#
# Usage:
#   export KEYSTORE_BASE64="<base64-encoded-keystore>"
#   ./decode-keystore.sh
#
# Output:
#   - Creates a temporary .jks file with chmod 600 permissions
#   - Writes the keystore path to keystore_path.txt
#   - Prints the keystore path to stdout
#
# Exit codes:
#   0 - Success
#   1 - Missing KEYSTORE_BASE64 environment variable
#   2 - Base64 decode failed
#   3 - File permissions could not be set

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print error messages
error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
}

# Function to print success messages
success() {
    echo -e "${GREEN}$1${NC}"
}

# Function to print warning messages
warn() {
    echo -e "${YELLOW}WARNING: $1${NC}"
}

# Check if KEYSTORE_BASE64 environment variable is set
if [ -z "${KEYSTORE_BASE64:-}" ]; then
    error "KEYSTORE_BASE64 environment variable is not set"
    error "Please set KEYSTORE_BASE64 to your base64-encoded keystore"
    exit 1
fi

# Create a temporary file for the keystore
TEMP_DIR="/tmp/android-keystore-$$"
mkdir -p "$TEMP_DIR"
chmod 700 "$TEMP_DIR"

KEYSTORE_FILE="$TEMP_DIR/release-keystore.jks"

# Decode base64 to keystore file
echo "Decoding base64 keystore..."
if ! echo "$KEYSTORE_BASE64" | base64 -d > "$KEYSTORE_FILE" 2>/dev/null; then
    error "Failed to decode base64 keystore"
    error "Please verify that KEYSTORE_BASE64 contains valid base64 data"
    rm -rf "$TEMP_DIR"
    exit 2
fi

# Verify the file was created and has content
if [ ! -s "$KEYSTORE_FILE" ]; then
    error "Decoded keystore file is empty"
    rm -rf "$TEMP_DIR"
    exit 2
fi

# Set restrictive permissions (read/write for owner only)
if ! chmod 600 "$KEYSTORE_FILE"; then
    error "Failed to set permissions on keystore file"
    rm -rf "$TEMP_DIR"
    exit 3
fi

# Write the keystore path to a file for the workflow to read
echo "$KEYSTORE_FILE" > keystore_path.txt

# Print success message and path
success "Keystore decoded successfully"
echo "Keystore path: $KEYSTORE_FILE"
echo "Keystore size: $(stat -f%z "$KEYSTORE_FILE" 2>/dev/null || stat -c%s "$KEYSTORE_FILE" 2>/dev/null) bytes"
echo "Permissions: $(ls -l "$KEYSTORE_FILE" | awk '{print $1}')"

# Output the path for the calling script
echo "$KEYSTORE_FILE"

exit 0
