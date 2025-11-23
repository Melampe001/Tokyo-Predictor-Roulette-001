#!/bin/bash
# Script to decode base64-encoded keystore from environment variable
# and write it to a temporary file with secure permissions.
# 
# Required environment variable:
#   KEYSTORE_BASE64 - Base64-encoded keystore content
#
# Outputs:
#   Prints the path to the decoded keystore file on success
#
# Exit codes:
#   0 - Success
#   1 - Missing environment variable
#   2 - Decode error

set -e

# Check if KEYSTORE_BASE64 environment variable is set
if [ -z "$KEYSTORE_BASE64" ]; then
    echo "Error: KEYSTORE_BASE64 environment variable is not set." >&2
    exit 1
fi

# Create a temporary file for the keystore in the system's secure temporary directory
KEYSTORE_FILE=$(mktemp "${TMPDIR:-/tmp}/keystore.XXXXXX.jks")

# Decode the base64 content and write to the temporary file
if ! echo "$KEYSTORE_BASE64" | base64 -d > "$KEYSTORE_FILE" 2>/tmp/decode_error.log; then
    echo "Error: Failed to decode KEYSTORE_BASE64. Please verify the base64 encoding is valid." >&2
    if [ -s /tmp/decode_error.log ]; then
        echo "Error: Decode operation failed. Check base64 format." >&2
    fi
    rm -f "$KEYSTORE_FILE" /tmp/decode_error.log
    exit 2
fi
rm -f /tmp/decode_error.log

# Set restrictive permissions (read/write only for owner)
chmod 600 "$KEYSTORE_FILE"

# Verify the file was created and has content
if [ ! -s "$KEYSTORE_FILE" ]; then
    echo "Error: Decoded keystore file is empty." >&2
    rm -f "$KEYSTORE_FILE"
    exit 2
fi

# Output the keystore path
echo "$KEYSTORE_FILE"
