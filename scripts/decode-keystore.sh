#!/bin/bash

# decode-keystore.sh
# Decodes a base64-encoded Android keystore from environment variable
# and writes it to a temporary file with secure permissions.
#
# Required environment variables:
#   KEYSTORE_BASE64: The base64-encoded keystore content
#
# Output:
#   Prints the absolute path to the decoded keystore file
#
# Exit codes:
#   0: Success
#   1: Missing environment variable
#   2: Base64 decode error
#   3: File write error

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print error messages
error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
}

# Function to print info messages
info() {
    echo -e "${GREEN}INFO: $1${NC}" >&2
}

# Function to print warning messages
warning() {
    echo -e "${YELLOW}WARNING: $1${NC}" >&2
}

# Check if KEYSTORE_BASE64 environment variable is set
if [[ -z "${KEYSTORE_BASE64:-}" ]]; then
    error "KEYSTORE_BASE64 environment variable is not set"
    error "Please set KEYSTORE_BASE64 with your base64-encoded keystore"
    exit 1
fi

# Create a temporary file for the keystore
KEYSTORE_FILE=$(mktemp /tmp/keystore.XXXXXXXXXX.jks)

if [[ ! -f "$KEYSTORE_FILE" ]]; then
    error "Failed to create temporary file for keystore"
    exit 3
fi

info "Decoding keystore to temporary file..."

# Decode the base64 keystore and write to file
if ! echo "$KEYSTORE_BASE64" | base64 -d > "$KEYSTORE_FILE" 2>/dev/null; then
    error "Failed to decode base64 keystore"
    error "Please verify that KEYSTORE_BASE64 contains valid base64 data"
    rm -f "$KEYSTORE_FILE"
    exit 2
fi

# Verify the file was created and has content
if [[ ! -s "$KEYSTORE_FILE" ]]; then
    error "Decoded keystore file is empty"
    rm -f "$KEYSTORE_FILE"
    exit 3
fi

# Set restrictive permissions (owner read/write only)
if ! chmod 600 "$KEYSTORE_FILE"; then
    error "Failed to set permissions on keystore file"
    rm -f "$KEYSTORE_FILE"
    exit 3
fi

# Get permissions in a portable way
PERMS=$(stat -c '%a' "$KEYSTORE_FILE" 2>/dev/null || stat -f '%OLp' "$KEYSTORE_FILE" 2>/dev/null || echo "unknown")

info "Keystore decoded successfully"
info "File: $KEYSTORE_FILE"
info "Permissions: $PERMS"

# Output the keystore path (this is captured by the caller)
echo "$KEYSTORE_FILE"

exit 0