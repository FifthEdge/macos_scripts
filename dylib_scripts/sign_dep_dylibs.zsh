#!/bin/zsh

# Check if arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <DEVELOPER_ID> <FRAMEWORKS_DIR>"
    echo "Example: code_sign "Developer ID Application: YOUR_ID (11YYXXXZZZ)"
    exit 1
fi

DEVELOPER_ID="$1"
FRAMEWORKS_DIR="$2"

# Code sign each .dylib file
find "$FRAMEWORKS_DIR" -type f -name "*.dylib" | while read -r lib; do
    echo "Signing $lib"
    codesign --sign "$DEVELOPER_ID" --force --timestamp --options runtime "$lib"
done

echo "Code signing complete"

